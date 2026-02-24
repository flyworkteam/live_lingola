import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/widgets/chat/chat_bubble.dart';
import '../../Core/widgets/chat/chat_chip.dart';
import '../../Core/widgets/chat/chat_input.dart';
import '../../Core/widgets/chat/chat_message.dart';
import '../../Core/widgets/chat/chat_top_bar.dart';

class AiChatView extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const AiChatView({super.key, this.onBackToHome});

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  final List<ChatMessage> _messages = const [
    ChatMessage(
      fromBot: true,
      text:
          "Hello! I'm your AI Travel Assistant. I can help you find flights, suggest\nlocal attractions, or even translate common phrases. How can I assist\nyou today? ✈️",
    ),
    ChatMessage(
      fromBot: false,
      text:
          "I'm planning a trip to Tokyo next\nmonth. Can you recommend some\nmust-visit hidden gems?",
    ),
    ChatMessage(
      fromBot: true,
      text:
          "Tokyo is amazing! Aside from the\nusual spots, you should definitely\ncheck out:\n• Shimokitazawa: Great for\n  vintage shopping and cool cafes.\n• Yanaka Ginza: A preserved \"Old\n  Tokyo\" shopping street.",
      actionText: "VIEW ON MAP",
    ),
  ];

  late final List<ChatMessage> _mutableMessages =
      List<ChatMessage>.from(_messages);

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _mutableMessages.add(ChatMessage(fromBot: false, text: text));
      _controller.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 300,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
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

    const botIconAsset = 'assets/images/icons/actions/ic_action_ai_chat.png';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: Column(
        children: [
          SizedBox(height: topPad + 10.h),
          ChatTopBar(
            onBack: () {
              if (widget.onBackToHome != null) {
                widget.onBackToHome!();
              } else {
                Navigator.pop(context);
              }
            },
            title: 'Ai Chat',
            iconAsset: botIconAsset,
          ),
          SizedBox(height: 6.h),
          Text(
            "TODAY, 10:24 AM",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
              itemCount: _mutableMessages.length,
              itemBuilder: (context, i) => ChatBubble(
                msg: _mutableMessages[i],
                botIconAsset: botIconAsset,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  ChatChip(text: "🇯🇵 Best Sushi?"),
                  ChatChip(text: "🏨 Hotel Tips"),
                  ChatChip(text: "🚇 Transit Guide"),
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
