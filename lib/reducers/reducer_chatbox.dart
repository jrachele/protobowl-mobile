import 'dart:collection';
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
      LinkedHashMap<String, Message> messages;
      if (prev.chatbox.messages != null ) {
        messages = prev.chatbox.messages;
      }
      else {
        messages = LinkedHashMap<String, Message>();
      }
        if (jsonData["name"] == "chat") {
          // We must update the chatbox
          jsonData = jsonData["args"][0];
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
              name: prev.room.users.where((user) => user["id"] == jsonData["user"]).first["name"],
            );
          }

        } else if (jsonData["name"] == "sync") {
          // It is possible a user has buzzed.
          jsonData = jsonData["args"][0];
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
              Iterable<dynamic> potentialUsers = prev.room.users.where((user) => user["id"] == jsonData["user"]);
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
        } else if (jsonData["name"] == "log") {
          jsonData = jsonData["args"][0];
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
        else {
          return prev.chatbox;
        }

        // Now that we have the children, we have the chatbox.
        return Chatbox(
            messages: messages
        );
      }
    }
    return prev.chatbox;
  }
