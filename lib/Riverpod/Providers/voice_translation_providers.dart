import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Controllers/VoiceTranslationController/voice_translation_controller.dart';

final voiceProLiveControllerProvider =
    StateNotifierProvider<VoiceProLiveController, VoiceProLiveState>(
  (ref) => VoiceProLiveController(),
);
