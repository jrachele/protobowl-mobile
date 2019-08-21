class Question {
  final String qid;
  final String question;
  final String answer;
  final String category;
  final String difficulty;

  final List<dynamic> timings;
  final int beginTime;
  final int endTime;

  Question( {this.qid, this.question, this.answer, this.category, this.difficulty, this.timings, this.beginTime, this.endTime = 0} );

  @override
  String toString() {
    return 'Question: \nqid: ${this.qid}\nquestion: ${this.question}\nanswer: ${this.answer}\ncategory: $category\ndifficulty: $difficulty\n';
  }
}