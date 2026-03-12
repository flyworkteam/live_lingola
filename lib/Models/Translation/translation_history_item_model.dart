class TranslationHistoryItemModel {
  final String id;
  final String sourceText;
  final String translatedText;
  final String sourceLanguageCode;
  final String sourceLanguageName;
  final String targetLanguageCode;
  final String targetLanguageName;
  final String expert;
  final bool isFavorite;
  final DateTime createdAt;

  const TranslationHistoryItemModel({
    required this.id,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguageCode,
    required this.sourceLanguageName,
    required this.targetLanguageCode,
    required this.targetLanguageName,
    required this.expert,
    required this.isFavorite,
    required this.createdAt,
  });

  TranslationHistoryItemModel copyWith({
    String? id,
    String? sourceText,
    String? translatedText,
    String? sourceLanguageCode,
    String? sourceLanguageName,
    String? targetLanguageCode,
    String? targetLanguageName,
    String? expert,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return TranslationHistoryItemModel(
      id: id ?? this.id,
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      sourceLanguageCode: sourceLanguageCode ?? this.sourceLanguageCode,
      sourceLanguageName: sourceLanguageName ?? this.sourceLanguageName,
      targetLanguageCode: targetLanguageCode ?? this.targetLanguageCode,
      targetLanguageName: targetLanguageName ?? this.targetLanguageName,
      expert: expert ?? this.expert,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TranslationHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return TranslationHistoryItemModel(
      id: json['id'] as String,
      sourceText: json['sourceText'] as String,
      translatedText: json['translatedText'] as String,
      sourceLanguageCode: json['sourceLanguageCode'] as String,
      sourceLanguageName: json['sourceLanguageName'] as String,
      targetLanguageCode: json['targetLanguageCode'] as String,
      targetLanguageName: json['targetLanguageName'] as String,
      expert: json['expert'] as String,
      isFavorite: json['isFavorite'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceText': sourceText,
      'translatedText': translatedText,
      'sourceLanguageCode': sourceLanguageCode,
      'sourceLanguageName': sourceLanguageName,
      'targetLanguageCode': targetLanguageCode,
      'targetLanguageName': targetLanguageName,
      'expert': expert,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
