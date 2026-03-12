class UserPreferencesModel {
  final String nativeLanguage;
  final String targetLanguage;
  final String level;
  final List<String> goals;
  final String dailyGoal;
  final String reason;

  const UserPreferencesModel({
    required this.nativeLanguage,
    required this.targetLanguage,
    required this.level,
    required this.goals,
    required this.dailyGoal,
    required this.reason,
  });

  UserPreferencesModel copyWith({
    String? nativeLanguage,
    String? targetLanguage,
    String? level,
    List<String>? goals,
    String? dailyGoal,
    String? reason,
  }) {
    return UserPreferencesModel(
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      level: level ?? this.level,
      goals: goals ?? this.goals,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nativeLanguage': nativeLanguage,
      'targetLanguage': targetLanguage,
      'level': level,
      'goals': goals,
      'dailyGoal': dailyGoal,
      'reason': reason,
    };
  }

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      nativeLanguage: json['nativeLanguage'] ?? '',
      targetLanguage: json['targetLanguage'] ?? '',
      level: json['level'] ?? '',
      goals: List<String>.from(json['goals'] ?? const []),
      dailyGoal: json['dailyGoal'] ?? '',
      reason: json['reason'] ?? '',
    );
  }

  factory UserPreferencesModel.empty() {
    return const UserPreferencesModel(
      nativeLanguage: '',
      targetLanguage: '',
      level: '',
      goals: [],
      dailyGoal: '',
      reason: '',
    );
  }
}
