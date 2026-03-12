enum AiChatRole {
  user,
  model,
}

class AiChatMessageModel {
  final String id;
  final String text;
  final AiChatRole role;
  final DateTime createdAt;

  const AiChatMessageModel({
    required this.id,
    required this.text,
    required this.role,
    required this.createdAt,
  });

  AiChatMessageModel copyWith({
    String? id,
    String? text,
    AiChatRole? role,
    DateTime? createdAt,
  }) {
    return AiChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
