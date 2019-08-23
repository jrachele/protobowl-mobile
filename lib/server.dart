import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http; // for requesting protobowl's socket
import 'package:sqflite/sqflite.dart';

import 'database.dart';


class Server{
  final String server = "ocean.protobowl.com:80/socket.io/1/websocket/";
  IOWebSocketChannel channel;
  Future<Database> database;
  String roomName;
  Timer timer;
  Function(Timer) timerCallback;

  Future<IOWebSocketChannel> getChannel() async {
    final response = await http.get('http://' + server);
    String sock = response.body.split(":")[0];
    print("Socket ID obtained: $sock");
    return IOWebSocketChannel.connect("ws://"+server+sock);
  }

  void buzz(String qid){
    if (qid != null) {
      String buzz = '5:23+::{"name":"buzz","args":["$qid"]}';
      channel.sink.add(buzz);
      print("Buzzed");
    }
  }

  void typing(String text) {
    if (channel != null) {
      String answer = '5:::{"name":"guess","args":[{"text":"'
          '$text","done":false},null]}';
      channel.sink.add(answer);
    }
  }

  void setName(String name) {
    String setName = '5:::{"name":"set_name","args":["' + name + '",null]}';
    channel.sink.add(setName);
  }

  void pushAnswer(String text) {
    if (channel != null) {
      String ans = '5:::{"name":"guess","args":[{"text":"$text","done":true},null]}';
      channel.sink.add(ans);
      print("Guessed");
    }
  }
    void next() {
    String next = '5:::{"name":"next","args":[null,null]}';
    channel.sink.add(next);
    print("Next");
  }

  void skip() {
    String skip = '5:::{"name":"skip","args":[null,null]}';
    channel.sink.add(skip);
    print("Skip");
  }

  void checkPublic() {
    String checkPublic = '5:1+::{"name":"check_public","args":[null,null]}';
    channel.sink.add(checkPublic);
    print("Checked Public");
  }

  void finish() {
    String finish = '5:::{"name":"finish","args":[null,null]}';
    channel.sink.add(finish);
    print("Finish");
  }

  void ping() {
    channel.sink.add("2::");
    print("Pinged");
  }

  void joinRoom(String room) async {
    String cookie;
    // Make sure to update database information if need be
    final Database db = await database;
    final List<Map<String, dynamic>> objects = await db.query("rooms");
    if (objects.isEmpty) {
      cookie = _randomString(41);
      final DatabaseModel model = DatabaseModel(
          id: 0,
          room: room,
          cookie: cookie
      );
      await db.insert("rooms", model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      cookie = objects[0]["cookie"];
      final DatabaseModel model = DatabaseModel(
        id: 0,
        room: room,
        cookie: cookie
      );
      await db.update("rooms", model.toMap(), where: "id=0");
    }

    print("Cookie: $cookie");
    String joinRoom =
        '5:::{"name":"join","args":[{"cookie":"$cookie","auth":null,"question_type":"qb","room_name":"$room","muwave":false,"agent":"M4/Web",'
        '"agent_version":"Sat Sep 02 2017 11:33:43 GMT-0700 (PDT)",'
        '"version":8}]}';
    print("joinRoom: $joinRoom");
    channel?.sink?.add(joinRoom);
    this.roomName = room;
  }

  String _randomString(int len) {
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
