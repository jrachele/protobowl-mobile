import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http; // for requesting protobowl's socket

String server = "ocean.protobowl.com:443/socket.io/1/websocket/";
var channel; // web socket channel
var state = GameState.RUNNING;
enum GameState {
  RUNNING,
  PAUSED,
  BUZZED,
  PROMPTED,
  IDLE,
  NEWQUESTION,
}
String qid; // important for buzzing in
String appBarText = "Protobowl";
String answer;
String room;
String category;
String questionText = "";
var question;
var rate;

var done = false;

var syllables;

var sockTime = 0;
var endTime = 0;

bool buzzed = false;
Map jsonData; // map
Map oldSync;
Map newSync;

void joinRoom(String room) {
  String cookie = _randomString(41);
  print("Cookie: $cookie");
  String joinRoom =
      '5:::{"name":"join","args":[{"cookie":"$cookie","auth":null,"question_type":"qb","room_name":"$room","muwave":false,"agent":"M4/Web",'
      '"agent_version":"Sat Sep 02 2017 11:33:43 GMT-0700 (PDT)",'
      '"version":8}]}';
  print("joinRoom: $joinRoom");
  channel.sink.add(joinRoom);
}

String format(String str) {
  // this method will format answer lines
  return str.split("[")[0].split("(")[0].split(" or ")[0].replaceAll("{", "").replaceAll("}","");
}

void setName(String name) {
  String setName = '5:::{"name":"set_name","args":["' + name + '",null]}';
  channel.sink.add(setName);
  print("Changed name to: $name");
}

bool updateData(String data) {
  if (data.startsWith("2::")) ping();
  // first we will make sure our response is JSON
  if (data.contains("{")) { // cursory analysis but YOLO
    data = data.substring(data.indexOf("{"), data.length);
    jsonData = JSON.decode(data);
    if (jsonData['name'] == 'sync') {
      try {
        newSync = jsonData['args'][0];
        if (oldSync == null) {
          oldSync = newSync; // update boi
        } else {
          if (oldSync['real_time'] == newSync['real_time']) {
            print("real_time is the same as the previous sync");
            return false; // no new information
          }
        }


//        newSync.forEach((key, value) {
//          print("KEY= $key ; VALUE= $value");
//        });

        if (newSync['real_time'] != null && newSync['time_offset'] != null) {
          // if we receive new times, we will update sockTime with the official boi
          sockTime = newSync['real_time'] - newSync['time_offset'];
        }
        if (newSync['end_time'] != null) {
          endTime = newSync['end_time'];
        }


          
        // baseTime = sockTime;
        // totalTime = newSync['end_time'] - baseTime;
        if (sockTime < endTime) {
          state = GameState.RUNNING;
        } else {
          state = GameState.IDLE;
          showQuestion();
        }

        if (newSync['time_freeze'] != 0) {
          state = GameState.BUZZED;
        } else if (newSync['qid'] != qid) {
          state = GameState.NEWQUESTION;
          questionText = "";
          done = false;
        } else {
          buzzed = false;
          done = false;
          state = GameState.RUNNING;
        }

        oldSync = newSync;

//      if (newSync['qid'] != null
//          && newSync['question'] != null
//          && newSync['answer'] != null
//      && newSync['name'] != null
//      && newSync['real_time'] != null) {

        qid = newSync['qid'] ?? qid;
        question = newSync['question'].split(" ") ?? question;
        answer = newSync['answer'] ?? answer;
        room = newSync['name'] ?? room;
        category = newSync['info']['category'] ?? category;
        syllables = newSync['timing'] ?? syllables;
        rate = newSync['rate'] ?? rate;

        // checkPublic();
//        print("System Time: ${new DateTime.now().millisecond}");
//
//
//      }
        
      } catch (Exception) {
        print(Exception.toString());
      }
    }
  }
  
  return true; // if we get to this point, the data is changed
}

void pushAnswer(String text) {
  if (channel != null) {
    String ans = '5:::{"name":"guess","args":[{"text":"$text","done":true},null]}';
    channel.sink.add(ans);
    print("Guessed");
  }
}

void showQuestion() {
  questionText = question.join(" ");
}

void buzz(){
  if (qid != null) {
    String buzz = '5:23+::{"name":"buzz","args":["$qid"]}';
    channel.sink.add(buzz);
    print("Buzzed");
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

Future<String> getSocket() async {
  final response = await http.get('http://' + server);
  var sock = response.body.split(":")[0];
  print("Socket ID obtained: $sock");
  return sock;
}

Future<IOWebSocketChannel> getChannel() async {
  String sock = await getSocket();
  return new IOWebSocketChannel.connect("ws://"+server+sock);
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