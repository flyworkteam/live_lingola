import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_pro_background_painter.dart'
    show ProStage;

class VoiceProLiveState {
  final ProStage stage;
  const VoiceProLiveState({required this.stage});

  VoiceProLiveState copyWith({ProStage? stage}) {
    return VoiceProLiveState(stage: stage ?? this.stage);
  }
}

class VoiceProLiveController extends StateNotifier<VoiceProLiveState> {
  VoiceProLiveController()
      : super(const VoiceProLiveState(stage: ProStage.empty));

  void tapMic() {
    final s = state.stage;
    if (s == ProStage.empty) {
      state = state.copyWith(stage: ProStage.listening);
    } else if (s == ProStage.listening) {
      state = state.copyWith(stage: ProStage.result);
    } else {
      state = state.copyWith(stage: ProStage.empty);
    }
  }

  void setStage(ProStage stage) {
    state = state.copyWith(stage: stage);
  }
}
