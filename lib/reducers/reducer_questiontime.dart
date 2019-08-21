import 'dart:convert';
import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


int questionTimeReducer(AppState prev, dynamic action) {
  if (action is TickAction) {
    if (prev.state == GameState.RUNNING) {
      return prev.questionTime + prev.room.rate;
    }
    return prev.questionTime;
  } else if (action is ReceivePacketAction) {
    String packet = action.packet;
    if (packet.contains("{")) {
      String data = packet.substring(packet.indexOf("{"));
      var jsonData = json.decode(data);
      // Determine if the JSON represents a question or other cursory info
      if (jsonData["name"] != "sync") return prev.questionTime;
      jsonData = jsonData["args"][0];
      if (jsonData["question"] == null) return prev.questionTime;

      // Attempt is always null if nobody has buzzed
      if (jsonData["attempt"] == null) {
        return max(prev.questionTime, jsonData["real_time"] - jsonData["time_offset"]);
      } else {
        return prev.questionTime;
      }
    }
  }

  return prev.questionTime;
}
