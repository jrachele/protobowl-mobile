class Room {
  final String name;
  final int rate;
  final List<dynamic> users;
  final bool allowMultipleBuzzes;
  final bool allowSkipQuestions;
  final bool allowPauseQuestions;
  final String category;
  final String difficulty;

  // Scoring is rather complicated. Basially this Map comes from a json object
  // such that scoring will show:
  // "interrupt" -> [# of points if correct, # of points if incorrect]
  // "early" -> [# of points if correct, # of points if incorrect]
  // "normal" -> [# of points if correct, # of points if incorrect]
  final Map<String, dynamic> scoring;

  Room({this.name, this.rate, this.users, this.scoring, this.allowMultipleBuzzes, this.allowPauseQuestions, this.allowSkipQuestions, this.category, this.difficulty});

  @override
  String toString() {
    return "Rate: $rate";
  }
}