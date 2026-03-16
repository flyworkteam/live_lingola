import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/Utils/assets.dart';
import '../../Core/widgets/chat/chat_bubble.dart';
import '../../Core/widgets/chat/chat_chip.dart';
import '../../Core/widgets/chat/chat_input.dart';
import '../../Core/widgets/chat/chat_message.dart';
import '../../Core/widgets/chat/chat_top_bar.dart';
import '../../Repositories/ai_repository.dart';
import '../../Services/AI/gemini_service.dart';

class AiChatView extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const AiChatView({super.key, this.onBackToHome});

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final AiRepository _repository = AiRepository(GeminiService.instance);

  final List<ChatMessage> _messages = const [
    ChatMessage(
      fromBot: true,
      text: "Hello! I'm your AI Travel Assistant...",
    ),
    ChatMessage(
      fromBot: false,
      text: "I'm planning a trip to Tokyo...",
    ),
    ChatMessage(
      fromBot: true,
      text: "Tokyo is amazing!...",
      actionText: "VIEW ON MAP",
    ),
  ];

  late final List<ChatMessage> _mutableMessages =
      List<ChatMessage>.from(_messages);

  bool _isBotTyping = false;
  String? _errorText;
  int _replyToken = 0;

  late LingolaChatSession _chat;

  @override
  void initState() {
    super.initState();
    _chat = _repository.startChat();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isBotTyping) return;

    setState(() {
      _mutableMessages.add(ChatMessage(fromBot: false, text: text));
      _controller.clear();
      _isBotTyping = true;
      _errorText = null;
      _replyToken++;
    });

    _scrollToBottom();

    final currentToken = _replyToken;

    try {
      final dynamic rawReply = await _repository.sendMessage(
        chat: _chat,
        text: text,
      );

      if (!mounted || currentToken != _replyToken) return;

      final String safeReply = rawReply?.toString().trim() ?? '';

      setState(() {
        _mutableMessages.add(
          ChatMessage(
            fromBot: true,
            text: safeReply.isNotEmpty
                ? safeReply
                : 'Sorry, I could not generate a response.',
          ),
        );
        _isBotTyping = false;
      });
    } catch (e, st) {
      debugPrint('AI CHAT ERROR: $e');
      debugPrintStack(stackTrace: st);

      if (!mounted || currentToken != _replyToken) return;

      setState(() {
        _isBotTyping = false;
        _errorText = e.toString();
        _mutableMessages.add(
          const ChatMessage(
            fromBot: true,
            text: 'Sorry, something went wrong. Please try again.',
          ),
        );
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 300,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendChipMessage(String text) {
    _controller.text = text;
    _send();
  }

  void _handleBack() {
    final onBack = widget.onBackToHome;
    if (onBack != null) {
      onBack();
      return;
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomReserve = 62.h + 12.h;
    final itemCount = _mutableMessages.length + (_isBotTyping ? 1 : 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: Column(
        children: [
          SizedBox(height: topPad + 10.h),
          ChatTopBar(
            onBack: _handleBack,
            title: 'Ai Chat',
            iconAsset: AppAssets.icAiChat,
          ),
          SizedBox(height: 6.h),
          Text(
            "TODAY, 10:24 AM",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.sp,
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
              itemCount: itemCount,
              itemBuilder: (context, i) {
                if (_isBotTyping && i == itemCount - 1) {
                  return const ChatBubble(
                    msg: ChatMessage(
                      fromBot: true,
                      text: 'Typing...',
                    ),
                    botIconAsset: AppAssets.icAiChat,
                  );
                }

                return ChatBubble(
                  msg: _mutableMessages[i],
                  botIconAsset: AppAssets.icAiChat,
                );
              },
            ),
          ),
          if (_errorText != null)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
              child: Text(
                _errorText ?? '',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11.sp,
                  color: Colors.red,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _sendChipMessage("Best sushi in Tokyo?"),
                    child: const ChatChip(text: "🇯🇵 Best Sushi?"),
                  ),
                  GestureDetector(
                    onTap: () => _sendChipMessage("Any hotel tips for Tokyo?"),
                    child: const ChatChip(text: "🏨 Hotel Tips"),
                  ),
                  GestureDetector(
                    onTap: () =>
                        _sendChipMessage("Can you explain Tokyo transit?"),
                    child: const ChatChip(text: "🚇 Transit Guide"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          ChatInputBar(
            controller: _controller,
            onSend: _send,
          ),
          SizedBox(height: 60.h + bottomReserve),
        ],
      ),
    );
  }
}
