import 'dart:convert';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


bool buzzedReducer(AppState prev, dynamic action) {
  if (action is BuzzAction) {
    if (prev.state == GameState.RUNNING) {
      // We are allowed to buzz
      return true;
    }
  } else if (action is SyncAction) {
    dynamic jsonData = action.data;
    if (jsonData["attempt"] == null) return prev.buzzed;
    jsonData = jsonData["attempt"];
    if (jsonData["done"] != null && jsonData["done"] == true && jsonData["correct"] != "prompt") {
      return false;
    }
  }
  return prev.buzzed;
}
