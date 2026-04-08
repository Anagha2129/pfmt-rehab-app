import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();

  bool isListening = false;

  Future<bool> init() async {
    return await _speech.initialize();
  }

  void startListening(Function(String) onResult) async {
    isListening = true;

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
    );
  }

  void stopListening() {
    isListening = false;
    _speech.stop();
  }
}