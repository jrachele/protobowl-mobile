import 'dart:convert';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


GameState gameStateReducer(AppState prev, dynamic action) {
  if (action is ReceivePacketAction) {
    String packet = action.packet;

    // Protobowl uses Socket.io which has a proprietary communications format
    // Luckily, the json data is delivered after a { character
    if (packet.contains("{")) {
      String data = packet.substring(packet.indexOf("{"));
      var jsonData = json.decode(data);
      if (jsonData["name"] != "sync") return prev.state;
      jsonData = jsonData["args"][0];
      // Attempt is always null if nobody has buzzed
//      if (jsonData["question"] == null) return prev.state;
      if (jsonData["attempt"] == null) {
        int accumulated_time = jsonData["real_time"] - jsonData["time_offset"];
        int end_time = jsonData["end_time"];
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
    }
    return prev.state;
  } else if (action is TickAction) {
    if (prev.questionTime >= prev.question.endTime) {
      return GameState.FINISHED;
    }
    return prev.state;
  }
  return prev.state;
}
