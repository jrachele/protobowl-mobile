import 'dart:convert';
import 'package:redux/redux.dart';

import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';

Question questionReducer(AppState prev, dynamic action) {
  if (action is SyncAction) {
    dynamic jsonData = action.data;
    if (jsonData["question"] == null) return prev.question;
    // Attempt is always null if nobody has buzzed
    if (jsonData["attempt"] == null) {
      return Question(
        qid: jsonData["qid"],
        question: jsonData["question"],
        answer: jsonData["answer"],
        category: jsonData["info"]["category"],
        difficulty: jsonData["info"]["difficulty"],
        beginTime: jsonData["begin_time"],
        endTime: jsonData["end_time"],
        timings: jsonData["timing"],
      );
    }

    return prev.question;
  }
  return prev.question;
}
