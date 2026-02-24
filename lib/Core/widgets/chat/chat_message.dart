class ChatMessage {
  final bool fromBot;
  final String text;
  final String? actionText;

  const ChatMessage({
    required this.fromBot,
    required this.text,
    this.actionText,
  });
}
