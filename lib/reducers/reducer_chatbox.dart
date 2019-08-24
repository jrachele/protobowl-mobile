import 'dart:convert';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


Chatbox chatBoxReducer(AppState prev, dynamic action) {
  if (action is ReceivePacketAction) {
    String packet = action.packet;

    // Protobowl uses Socket.io which has a proprietary communications format
    // Luckily, the json data is delivered after a { character
    if (packet.contains("{")) {
      String data = packet.substring(packet.indexOf("{"));
      var jsonData = json.decode(data);

    }
  }
}
