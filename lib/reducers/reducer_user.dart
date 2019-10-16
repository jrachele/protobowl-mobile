import 'dart:convert';
import 'package:redux/redux.dart';

import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


Player playerReducer(AppState prev, dynamic action) {
    if (action is JoinedAction) {
      // Assign userID immediately when player joins, since Protobowl does not
      // directly feed your exact userID to you when joining
      dynamic jsonData = action.data;
      if (prev.player.userID == null || prev.player.userID == jsonData["id"]) {
        return Player(
            name: jsonData["name"],
            userID: jsonData["id"]
        );
      }
    }

    if (action is SyncAction) {
      dynamic jsonData = action.data;
      List<dynamic> users = jsonData["users"];
      if (users == null) {
        return prev.player;
      }
      for (var user in users) {
        if (user["id"] == prev.player.userID) {
          // In case the name needs to be updated
          return Player(
              name: user["name"],
              userID: user["id"]
          );
        }
      }
    }

    return prev.player;
}
