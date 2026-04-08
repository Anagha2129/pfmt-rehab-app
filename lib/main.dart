import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/exercise_service.dart';
import 'services/speech_service.dart';
import 'services/voice_parser_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExerciseService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PFMT App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechService _speechService = SpeechService();
  final VoiceParserService _parser = VoiceParserService();

  bool isListening = false;

  String getPhaseText(ExercisePhase phase) {
    switch (phase) {
      case ExercisePhase.contract:
        return "Contract 💪";
      case ExercisePhase.hold:
        return "Hold ⏱️";
      case ExercisePhase.relax:
        return "Relax 😌";
      case ExercisePhase.rest:
        return "Rest 🧘";
    }
  }

  Future<void> _startListening() async {
    bool available = await _speechService.init();

    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Speech not available")),
      );
      return;
    }

    setState(() {
      isListening = true;
    });

    _speechService.startListening((text) {
      final result = _parser.parse(text);
      final exercise = context.read<ExerciseService>();

      print("User said: $text");

      // 🎯 CONNECT VOICE TO LOGIC
      if (result.completed) {
        exercise.completeEarly();
      }

      if (result.tooHard) {
        exercise.markTooHard();
      }

      if (result.reps != null) {
        exercise.updateRepsFromVoice(result.reps!);
      }

      if (text.toLowerCase().contains("stop")) {
        exercise.stopFromVoice();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Processed: $text")),
      );

      setState(() {
        isListening = false;
      });
    });
  }

  void _stopListening() {
    _speechService.stopListening();
    setState(() {
      isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PFMT Trainer"),
        centerTitle: true,
      ),
      body: Consumer<ExerciseService>(
        builder: (context, exercise, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Phase
                Text(
                  getPhaseText(exercise.phase),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Timer
                Text(
                  "${exercise.secondsRemaining}s",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Reps & Sets
                Text(
                  "Rep: ${exercise.currentRep} / ${exercise.repsPerSet}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Set: ${exercise.currentSet} / ${exercise.sets}",
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 40),

                // Start Button
                ElevatedButton(
                  onPressed: exercise.isRunning
                      ? null
                      : () => exercise.startExercise(),
                  child: const Text("Start Exercise"),
                ),

                const SizedBox(height: 10),

                // Stop Button
                ElevatedButton(
                  onPressed: exercise.isRunning
                      ? () => exercise.stopExercise()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Stop"),
                ),

                const SizedBox(height: 30),

                //  Mic Button
                ElevatedButton.icon(
                  onPressed: isListening ? _stopListening : _startListening,
                  icon: Icon(isListening ? Icons.stop : Icons.mic),
                  label: Text(isListening ? "Stop Listening" : "Speak"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}