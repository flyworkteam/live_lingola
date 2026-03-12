class OnboardingPreferencesModel {
  final String usagePurpose;
  final String fromLanguage;
  final String toLanguage;
  final String usedAiBefore;
  final String desiredFeature;

  const OnboardingPreferencesModel({
    required this.usagePurpose,
    required this.fromLanguage,
    required this.toLanguage,
    required this.usedAiBefore,
    required this.desiredFeature,
  });

  factory OnboardingPreferencesModel.empty() {
    return const OnboardingPreferencesModel(
      usagePurpose: '',
      fromLanguage: '',
      toLanguage: '',
      usedAiBefore: '',
      desiredFeature: '',
    );
  }

  OnboardingPreferencesModel copyWith({
    String? usagePurpose,
    String? fromLanguage,
    String? toLanguage,
    String? usedAiBefore,
    String? desiredFeature,
  }) {
    return OnboardingPreferencesModel(
      usagePurpose: usagePurpose ?? this.usagePurpose,
      fromLanguage: fromLanguage ?? this.fromLanguage,
      toLanguage: toLanguage ?? this.toLanguage,
      usedAiBefore: usedAiBefore ?? this.usedAiBefore,
      desiredFeature: desiredFeature ?? this.desiredFeature,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usagePurpose': usagePurpose,
      'fromLanguage': fromLanguage,
      'toLanguage': toLanguage,
      'usedAiBefore': usedAiBefore,
      'desiredFeature': desiredFeature,
    };
  }

  factory OnboardingPreferencesModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPreferencesModel(
      usagePurpose: json['usagePurpose'] ?? '',
      fromLanguage: json['fromLanguage'] ?? '',
      toLanguage: json['toLanguage'] ?? '',
      usedAiBefore: json['usedAiBefore'] ?? '',
      desiredFeature: json['desiredFeature'] ?? '',
    );
  }
}
