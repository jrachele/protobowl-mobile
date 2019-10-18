import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class Socket {
  static const EIO_VERSION = 3;
  IOWebSocketChannel channel;
  Map callbacks;
  String server;

  Socket() {
    callbacks = Map();
  }

  Future<bool> io(String server) async {
    bool secure = false;
    String domain;
    if (server.startsWith("https://")) {
      secure = true;
      domain = server.substring(8);
    } else if (server.startsWith("http://")) {
      secure = false;
      domain = server.substring(7);
    } else {
      return false;
    }

    if (!server.endsWith("/")) {
      server += "/";
    }
    this.server = server;
    // Contact the server for the socket id
    String serverConnection = server + "socket.io/?EIO=$EIO_VERSION&transport=polling";
    var response = await http.get(serverConnection).catchError((_) {
      return null;
    }).timeout(const Duration(milliseconds: 5000), onTimeout: () {
      return null;
    });
    if (response == null) {
      print("No response from $serverConnection");
      return false;
    }
    String responseJSON = "{" + response.body.split('{')[1];
    responseJSON = responseJSON.substring(0, responseJSON.length-4);
    var decodedJSON = json.decode(responseJSON);
    String sock = decodedJSON["sid"];
    String channelConnection = (secure ? "wss://" : "ws://") + domain + "socket.io/?EIO=$EIO_VERSION&transport=websocket&sid=$sock";
    channel = IOWebSocketChannel.connect(channelConnection,
      headers: {
//        "Host": domain,
        "Connection": "keep-alive, Upgrade",
        "Pragma": "no-cache",
        "Cache-Control": "no-cache",
        "Upgrade": "websocket",
        "Sec-WebSocket-Version": "13",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US;en;q=0.9",
        "Sec-WebSocket-Extensions": "permessage-deflate; client_max_window_bits"
      }
    );

    _probe();
    channel.stream?.listen((message) =>_onMessageReceived(message, echoMessages: true));
    Timer.periodic(Duration(milliseconds: 3000), (timer) => _ping());
    return channel != null;
  }

  Future<bool> refresh() {
    channel?.sink?.close();
    return io(this.server);
  }

  void emit(String name, [List<dynamic> arguments]) {
    if (channel != null) {
      String raw = '42["$name"';
      for (var argument in arguments) {
        raw += ', ${json.encode(argument)}';
      }
      raw += ']';
      channel.sink.add(raw);
    }
  }

  void on(String event, Function(dynamic data) func) {
    callbacks[event] = func;
  }

  void onConnected(Function() func) {
    callbacks["#"] = func;
  }

  void _onMessageReceived(dynamic message, {bool echoMessages=false}) {
    if (echoMessages) print(message);
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
        callback(jsonObject.sublist(1)[0]);
      }
    }
  }

  void _probe() {
    if (channel != null && channel.sink != null) {
      channel.sink.add("2probe");
    }
  }

  void _upgrade() {
    if (channel != null && channel.sink != null) {
      channel.sink.add("5");
    }
  }
  void _ping() {
    if (channel != null && channel.sink != null) {
      channel.sink.add("2");
    }
  }

}
