class ParsedVoiceInput {
  final bool completed;
  final bool tooHard;
  final int? reps;
  final String? difficulty;

  ParsedVoiceInput({
    required this.completed,
    required this.tooHard,
    this.reps,
    this.difficulty,
  });
}

class VoiceParserService {
  ParsedVoiceInput parse(String input) {
    input = input.toLowerCase();

    bool completed = input.contains("done") ||
        input.contains("completed") ||
        input.contains("finished");

    bool tooHard = input.contains("too hard") ||
        input.contains("difficult");

    int? reps;
    final regExp = RegExp(r'\d+');
    final match = regExp.firstMatch(input);

    if (match != null) {
      reps = int.tryParse(match.group(0)!);
    }

    String? difficulty;
    if (input.contains("easy")) {
      difficulty = "low";
    } else if (input.contains("hard")) {
      difficulty = "high";
    } else if (input.contains("manageable")) {
      difficulty = "medium";
    }

    return ParsedVoiceInput(
      completed: completed,
      tooHard: tooHard,
      reps: reps,
      difficulty: difficulty,
    );
  }
}