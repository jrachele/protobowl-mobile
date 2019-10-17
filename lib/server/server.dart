import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:package_info/package_info.dart';
import 'package:flutterbowl/server/database.dart';

import 'socket.dart';


class Server {
  final String server = "https://ocean.protobowl.com/";
  Socket socket;
  Future<Database> database;
  String roomName;
  PackageInfo packageInfo;
  Timer timer;
  Function(Timer) timerCallback;
  Function() finishChat;
  Function({String room}) refreshServer;


  void buzz(String qid){
    if (socket != null) {
      socket.emit("buzz", ["$qid"]);
      print("Buzzed");
    }
  }

  void typingAnswer(String text) {
    if (socket != null) {
      socket.emit("guess", [{
        "text": text,
        "done": false
      }, null]);
    }
  }

  void pushAnswer(String text) {
    if (socket != null) {
      socket.emit("guess", [{
        "text": text,
        "done": true
      }, null]);
    }
  }

  void typingMessage(String text, String session, bool done) {
    if (socket != null) {
      socket.emit("chat", [{
        "text": text,
        "session": session,
        "done": done
      }, null]);
    }
  }

  void setName(String name) {
    if (socket != null) {
      socket.emit("set_name", [name, null]);
    }
  }

  void setSpeed(double speed) {
    if (socket != null) {
      socket.emit("set_speed", [speed, null]);
    }
  }

  void setMultipleBuzzes(bool multipleBuzzes) {
    if (socket != null) {
      socket.emit("set_max_buzz", [multipleBuzzes ? null : 1, null]);
    }
  }

  void setSkipping(bool skipping) {
    if (socket != null) {
      socket.emit("set_skip", [skipping, null]);
    }
  }

  void setPausing(bool pausing) {
    if (socket != null) {
      socket.emit("set_pause", [pausing, null]);
    }
  }

  void setCategory(String category) {
    if (socket != null) {
      socket.emit("set_category", [category, null]);
    }
  }

  void setDifficulty(String difficulty) {
    if (socket != null) {
      socket.emit("set_difficulty", [difficulty, null]);
    }
  }

  void resetScore() {
    if (socket != null) {
      socket.emit("reset_score", [null, null]);
    }
  }

  void next() {
    if (socket != null) {
      socket.emit("next", [null, null]);
    }
  }

  void skip() {
    if (socket != null) {
      socket.emit("skip", [null, null]);
    }
  }

  void checkPublic() {
    if (socket != null) {
      socket.emit("check_public", [null, null]);
    }
  }

  void finish() {
    if (socket != null) {
      socket.emit("finish", [null, null]);
    }
  }

  void joinRoom(String room) async {
    String cookie;
    // Make sure to update database information if need be
    final Database db = await database;
    final List<Map<String, dynamic>> objects = await db.query("rooms");
    if (objects.isEmpty) {
      cookie = randomString(41);
      final DatabaseModel model = DatabaseModel(
          id: 0,
          room: room,
          cookie: cookie
      );
      await db.insert("rooms", model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      cookie = objects[0]["cookie"];
      if (room != null) {
        final DatabaseModel model = DatabaseModel(
            id: 0,
            room: room,
            cookie: cookie
        );
        await db.update("rooms", model.toMap(), where: "id=0");
      }
    }

    if (room == null) room = "hsquizbowl";

    if (socket != null) {
      socket.emit("join", [{
        "cookie": cookie,
        "auth": null,
        "question_type": "qb",
        "room_name": room,
        "muwave": false,
        "agent": "Mobile",
        "agent_version": "Flutterbowl Version ${packageInfo.version}",
        "referrers": ["https://protobowl.com/"],
        "version": 8
      }]);
    }
    this.roomName = room;
  }

  String randomString(int len) {
    final alpha =
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
    var str = '';
    for (int i =0; i < len; i++) {
      str += alpha[new Random().nextInt(alpha.length - 1)];
    }
    return str;
  }
}

final Server server = Server();
