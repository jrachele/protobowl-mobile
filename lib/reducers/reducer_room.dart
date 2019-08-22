import 'dart:convert';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


Room roomReducer(AppState prev, dynamic action) {
  if (action is ReceivePacketAction) {
    String packet = action.packet;

    // Protobowl uses Socket.io which has a proprietary communications format
    // Luckily, the json data is delivered after a { character
    if (packet.contains("{")) {
      String data = packet.substring(packet.indexOf("{"));
      var jsonData = json.decode(data);
      if (jsonData["name"] != "sync") return prev.room;
      jsonData = jsonData["args"][0];
      // Attempt is always null if nobody has buzzed

      if (jsonData["rate"] != null) {
        // This is me, being a very very bad boy
        // Start the global timer according to the server rate provided in the packet
        if (prev.room.rate != jsonData["rate"]) {
          // Update the timer
          server.timer.cancel();
          server.timer =
              Timer.periodic(Duration(milliseconds: jsonData["rate"].round()), server.timerCallback);
        }

        return Room(
            rate: jsonData["rate"].round(),
            users: jsonData["users"] ?? prev.room.users,
            scoring: jsonData["scoring"] ?? prev.room.scoring
        );
      }
    }
  }
  return prev.room;
}
