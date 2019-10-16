import 'dart:convert';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


GameState gameStateReducer(AppState prev, dynamic action) {
  if (action is SyncAction) {
    dynamic jsonData = action.data;
    if (jsonData["attempt"] == null) {
      int accumulated_time = jsonData["real_time"] - jsonData["time_offset"];
      int end_time = jsonData["end_time"];
      if (accumulated_time == null || end_time == null) return prev.state;
      if (accumulated_time < end_time) {
//          if (accumulated_time < end_time) {
        if (jsonData["time_freeze"] != 0) {
          return GameState.BUZZED;
        } else {
          return GameState.RUNNING;
        }
      } else {
        // Stop the timer
        return GameState.FINISHED;
      }
    } else {
      jsonData = jsonData["attempt"];
      if (jsonData["correct"] == "prompt") {
        return GameState.PROMPTED;
      } else {
        return GameState.BUZZED;
      }
    }
  } else if (action is TickAction) {
    if (prev.questionTime >= prev.question?.endTime) {
      return GameState.FINISHED;
    }
    return prev.state;
  }
  return prev.state;
}
