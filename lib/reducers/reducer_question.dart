import 'dart:convert';
import 'package:redux/redux.dart';

import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';

final questionsReducer = combineReducers<Question>([
  TypedReducer<Question, ReceivePacketAction>(_parsePacket),
]);

Question _parsePacket(Question prev, ReceivePacketAction action) {
  String packet = action.packet;


  // Protobowl uses Socket.io which has a proprietary communications format
  // Luckily, the json data is delivered after a { character
  if (packet.contains("{")) {
    String data = packet.substring(packet.indexOf("{"));
    var jsonData = json.decode(data);
    // Determine if the JSON represents a question or other cursory info
    if (jsonData["name"] != "sync") return prev;
    jsonData = jsonData["args"][0];
    if (jsonData["question"] == null) return prev;
    // Attempt is always null if nobody has buzzed
    if (jsonData["attempt"] == null) {
//      String category = jsonData["category"] == "" ? "Any Category" : jsonData["category"];
//      String difficulty = jsonData["difficulty"] == "" ? "Any Difficulty" : jsonData["difficulty"];
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
    } else {
      // This has nothing to do with questions, so the question is not updated
      return prev;
    }
  }
  return prev;
}
