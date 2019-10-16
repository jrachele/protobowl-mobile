import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


MessageWindow chatBoxReducer(AppState prev, dynamic action) {
  LinkedHashMap<String, Message> messages;
  if (prev.chatbox.messages != null ) {
    messages = prev.chatbox.messages;
  }
  else {
    messages = LinkedHashMap<String, Message>();
  }

  if (action is ServerChatAction) {
    dynamic jsonData = action.data;

    if (messages[jsonData["session"]] != null) {
      // We don't want to have to fetch the name if we don't have to
      messages[jsonData["session"]] = Message(
        message: jsonData["text"],
        complete: jsonData["done"],
        name: messages[jsonData["session"]].name,
      );
    } else {
      messages[jsonData["session"]] = Message(
        message: jsonData["text"],
        complete: jsonData["done"],
        // Get name of user given ID
        name: prev.room.users
            .where((user) => user["id"] == jsonData["user"])
            .first["name"],
      );
    }
  }

  if (action is SyncAction) {
    dynamic jsonData = action.data;

    // It is possible a user has buzzed.
    if (jsonData["attempt"] == null) return prev.chatbox;
    jsonData = jsonData["attempt"];

    if (messages[jsonData["session"]] != null) {
      messages[jsonData["session"]] = BuzzMessage(
          message: jsonData["text"],
          complete: jsonData["done"],
          name: messages[jsonData["session"]].name,
          early: jsonData["early"],
          correct: jsonData["correct"],
          prompt: jsonData["prompt"]
      );
    } else {
      String name = "A player";
      if (prev.room.users != null) {
        Iterable<dynamic> potentialUsers = prev.room.users.where((
            user) => user["id"] == jsonData["user"]);
        if (potentialUsers.isNotEmpty) {
          name = potentialUsers.first["name"];
        }
      }
      messages[jsonData["session"]] = BuzzMessage(
          message: jsonData["text"],
          complete: jsonData["done"],
          name: name,
          early: jsonData["early"],
          correct: jsonData["correct"],
          prompt: jsonData["prompt"]
      );
    }
  }

  if (action is LogAction) {
    dynamic jsonData = action.data;

    String name = "A player";
    // When you join a room in protobowl, a log shows up first, before
    // the username is actually known. So we must update the log if the
    // name is not there
    bool userNameExists = false;
    if (prev.room.users != null) {
      Iterable<dynamic> potentialUsers = prev.room.users.where((user) => user["id"] == jsonData["user"]);
      if (potentialUsers.isNotEmpty) {
        name = potentialUsers.first["name"];
        userNameExists = true;
      }
    }

    messages[jsonData["time"].toString()] = LogMessage(
      message: jsonData["verb"],
      name: name,
    );
  }
  // Now that we have the children, we have the chatbox.
  return MessageWindow(
      messages: messages
  );
}
