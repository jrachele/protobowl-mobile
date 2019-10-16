import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class Socket {
  static const EIO_VERSION = 3;
  IOWebSocketChannel channel;
  Map callbacks;
  Socket() {
    callbacks = Map();
  }

  Future<void> io(String server) async {
    bool secure = false;
    String domain;
    if (server.startsWith("https://")) {
      secure = true;
      domain = server.substring(8);
    } else if (server.startsWith("http://")) {
      secure = false;
      domain = server.substring(7);
    } else {
      throw Exception("Invalid server URL");
    }

    if (!server.endsWith("/")) {
      server += "/";
    }
    // Contact the server for the socket id
    String serverConnection = server + "socket.io/?EIO=$EIO_VERSION&transport=polling";
    final response = await http.get(serverConnection);
    String responseJSON = "{" + response.body.split('{')[1];
    responseJSON = responseJSON.substring(0, responseJSON.length-4);
    var decodedJSON = json.decode(responseJSON);
    String sock = decodedJSON["sid"];
    String channelConnection = (secure ? "wss://" : "ws://") + domain + "socket.io/?EIO=$EIO_VERSION&transport=websocket&sid=$sock";
    channel = IOWebSocketChannel.connect(channelConnection, pingInterval: Duration(milliseconds: 2500));
    _probe();
    channel.stream?.listen(_onMessageReceived);
  }

  void emit(String name, [List<dynamic> arguments]) {
    if (channel != null) {
      String raw = '42["$name"';
      for (var argument in arguments) {
        raw += ', ${json.encode(argument)}';
      }
      raw += ']';
      channel.sink.add(raw);
      print("Emitted: $raw");
    }
  }

  void on(String event, Function(Object data) func) {
    callbacks[event] = func;
  }

  void onConnected(Function() func) {
    callbacks["#"] = func;
  }

  void _onMessageReceived(dynamic message) {
    print(message);
    if (message == "3probe") {
      _upgrade();
      // OnConnected callback
      if (callbacks.containsKey("#")) {
        Function onConnected = callbacks["#"];
        onConnected();
      }
    }

    // Event handling
    if (message.toString().contains("[")) {
      String jsonReady = message.toString().substring(message.toString().indexOf("["));
      List jsonObject = json.decode(jsonReady);
      // Call the callback
//        func(jsonObject);
      String messageName = jsonObject[0];
      if (callbacks.containsKey(messageName)) {
        Function callback = callbacks[messageName];
        callback(jsonObject.sublist(1));
      }
    }
  }

  void _probe() {
    if (channel != null) {
      channel.sink.add("2probe");
    }
  }

  void _upgrade() {
    if (channel != null) {
      channel.sink.add("5");
    }
  }
  void _ping() {
    if (channel != null) {
      channel.sink.add("2");
    }
  }

}
