import 'dart:convert';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


Room roomReducer(AppState prev, dynamic action) {
  if (action is SyncAction) {
    dynamic jsonData = action.data;

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
          name: server.roomName,
          rate: jsonData["rate"].round(),
          users: jsonData["users"] ?? prev.room.users,
          scoring: jsonData["scoring"] ?? prev.room.scoring,
          allowMultipleBuzzes: jsonData["max_buzz"] == null,
          allowPauseQuestions: !jsonData["no_pause"],
          allowSkipQuestions: !jsonData["no_skip"],
          category: jsonData["category"],
          difficulty: jsonData["difficulty"]
      );
    } else {
      // If rate is null, one of the users got updated. Thanks Protobowl
      // for writing excellent code
      if (jsonData["users"] == null) return prev.room;
      String singleUserName = jsonData["users"][0]["name"];
      String singleUserID = jsonData["users"][0]["id"];
      List<dynamic> previousUsers = prev.room.users;
      for (var user in previousUsers) {
        if (user["id"] == singleUserID) {
          user["name"] = singleUserName;
        }
      }

      return Room(
          name: server.roomName,
          rate: prev.room.rate,
          users: previousUsers,
          scoring: prev.room.scoring,
          allowMultipleBuzzes: prev.room.allowMultipleBuzzes,
          allowPauseQuestions: prev.room.allowPauseQuestions,
          allowSkipQuestions: prev.room.allowSkipQuestions,
          category: prev.room.category,
          difficulty: prev.room.difficulty
      );
    }
  }
  return prev.room;
}
