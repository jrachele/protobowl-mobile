import 'dart:convert';
import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


int questionTimeReducer(AppState prev, dynamic action) {
  if (action is TickAction) {
    if (prev.state == GameState.RUNNING) {
      // On each tick, if the question is running we will update the question timer
      // because unfortunately it must be done client-side
      return prev.questionTime + prev.room.rate;
    } else if (prev.state == GameState.FINISHED) {
      // If the question is done, we will force the timer to the end just in case
      // (for example when a player buzzes and gets the answer correct)
      return prev.question.endTime;
    }
    return prev.questionTime;
  } else if (action is SyncAction) {
    dynamic jsonData = action.data;
    if (jsonData == null) return prev.questionTime;
      // Determine if the JSON represents a question or other cursory info
      if (jsonData["question"] == null) return prev.questionTime;
      // Attempt is always null if nobody has buzzed
      if (jsonData["attempt"] == null) {
        return max(prev.questionTime, jsonData["real_time"] - jsonData["time_offset"]);
      } else {
        return prev.questionTime;
      }
  }

  return prev.questionTime;
}
