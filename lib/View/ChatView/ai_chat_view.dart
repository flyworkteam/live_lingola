import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

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

  final List<ChatMessage> _messages = const [];

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    if (_mutableMessages.isEmpty) {
      _mutableMessages.add(
        ChatMessage(
          fromBot: true,
          text: l10n.aiChatWelcomeMessage,
        ),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

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

      final String safeReply = (rawReply?.toString() ?? '').trim();

      setState(() {
        _mutableMessages.add(
          ChatMessage(
            fromBot: true,
            text: safeReply.isEmpty
                ? l10n.aiChatErrorMessage('Empty response')
                : safeReply,
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
          ChatMessage(
            fromBot: true,
            text: l10n.aiChatErrorMessage('$e'),
          ),
        );
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;

      final target = _scroll.position.maxScrollExtent;

      if ((_scroll.offset - target).abs() < 2) return;

      _scroll.jumpTo(target);
    });
  }

  void _sendChipMessage(String text) {
    _controller.text = text;
    _send();
  }

  void _handleBack() {
    final backCallback = widget.onBackToHome;
    if (backCallback != null) {
      backCallback();
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
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }

    final topPad = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final itemCount = _mutableMessages.length + (_isBotTyping ? 1 : 0);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF3F6FB),
      body: Column(
        children: [
          SizedBox(height: topPad + 10.h),
          ChatTopBar(
            onBack: _handleBack,
            title: l10n.aiChatTitle,
            iconAsset: AppAssets.icAiChat,
          ),
          SizedBox(height: 6.h),
          Text(
            l10n.todayUppercase,
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
                  return ChatBubble(
                    msg: ChatMessage(
                      fromBot: true,
                      text: l10n.typing,
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
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _sendChipMessage(l10n.aiChatChipPromptSushi),
                    child: ChatChip(text: l10n.aiChatChipLabelSushi),
                  ),
                  GestureDetector(
                    onTap: () => _sendChipMessage(l10n.aiChatChipPromptHotel),
                    child: ChatChip(text: l10n.aiChatChipLabelHotel),
                  ),
                  GestureDetector(
                    onTap: () => _sendChipMessage(l10n.aiChatChipPromptTransit),
                    child: ChatChip(text: l10n.aiChatChipLabelTransit),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 6.h),
          AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: bottomInset > 0 ? 8.h : (safeBottom + 12.h),
            ),
            child: ChatInputBar(
              controller: _controller,
              onSend: _send,
            ),
          ),
        ],
      ),
    );
  }
}
