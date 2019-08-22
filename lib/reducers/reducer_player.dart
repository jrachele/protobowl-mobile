import 'dart:convert';
import 'package:redux/redux.dart';

import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';

final playerReducer = combineReducers<Player>([
  TypedReducer<Player, ReceivePacketAction>(_parsePacket),
]);

Player _parsePacket(Player prev, ReceivePacketAction action) {
  String packet = action.packet;


  // Protobowl uses Socket.io which has a proprietary communications format
  // Luckily, the json data is delivered after a { character
  if (packet.contains("{")) {
    String data = packet.substring(packet.indexOf("{"));
    var jsonData = json.decode(data);
    // Assign userID immediately when player joins, since Protobowl does not
    // directly feed your exact userID to you when joining
    if (jsonData["name"] == "joined" &&
        (prev.userID == null || prev.userID == jsonData["args"][0]["id"])) {
      jsonData = jsonData["args"][0];
      return Player(
        name: jsonData["name"],
        userID: jsonData["id"]
      );
    }

    if (jsonData["name"] == "sync") {
      jsonData = jsonData["args"][0];
      List<dynamic> users = jsonData["users"];
      for (var user in users) {
        if (user["id"] == prev.userID) {
          // In case the name needs to be updated
          return Player(
            name: user["name"],
            userID: user["id"]
          );
        }
      }
    }
  }
  return prev;
}
