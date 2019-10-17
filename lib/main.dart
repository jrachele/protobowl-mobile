import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/actions/actions.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/reducers/reducers.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'pages/protobowl.dart';
import 'pages/error.dart';
import 'server/socket.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async {
  // Establish a connection to sqlite database
  server.database = openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE rooms(id INTEGER PRIMARY KEY, room TEXT, cookie TEXT)",
      );
    },
// Set the version. This executes the onCreate function and provides a
// path to perform database upgrades and downgrades.
    version: 1,
  );
  final Database db = await server.database;
  List<Map<String, dynamic>> rooms = await db.query("rooms");
  String room = "flutterbowl";
  if (rooms.isNotEmpty) {
    room = rooms[0]["room"];
  }
  // Get package info
  server.packageInfo = await PackageInfo.fromPlatform();


  // Connect to Socket.io server (homegrown plugin)
  server.socket = Socket();
  bool connected = await server.socket.io(server.server);
//  print(connected);
  server.socket.onConnected(() {
    server.joinRoom(room);
  });
//
//  server.socket = IO.io('https://ocean.protobowl.com', <String, dynamic>{
//    'transports': ['websocket']
//  });
//
//  server.socket.on('connect', (_) {
//    server.joinRoom(room);
//  });

  runApp(new ProtobowlApp(connected));
}


class ProtobowlApp extends StatelessWidget {
  // Create the store, which is an immutable representation of our app state
  final store = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
//    middleware: [LoggingMiddleware.printer()]
  );
  final bool connected;

//  final TextEditingController answerController = TextEditingController();

  ProtobowlApp(this.connected) {
    // In this constructor, we will set up all callbacks to the socket
    // as well as timers

    server.socket.on("sync", (data) {
//      print(data);
      store.dispatch(SyncAction(data));
    });

    server.socket.on("log", (data) {
//      print(data);
      store.dispatch(LogAction(data));
    });

    server.socket.on("joined", (data) {
//      print(data);
      store.dispatch(JoinedAction(data));
    });

    server.socket.on("chat", (data) {
//      print(data);
      store.dispatch(ServerChatAction(data));
    });

    server.timerCallback = (Timer timer) => store.dispatch(TickAction());
    server.timer =
        Timer.periodic(Duration(milliseconds: 60), server.timerCallback);
    server.finishChat = () => store.dispatch(FinishChatAction());
    server.refreshServer = ({String room}) async {
      // When changing rooms, a new socket has to be fetched
      // otherwise Protobowl will count you as a zombie
      bool success = await server.socket.refresh();
      server.socket.onConnected(() {
        store.dispatch(RoomChangeAction());
        if (room != null) {
          server.joinRoom(room);
        } else {
          server.joinRoom(store.state.room.name);
        }
      });
      return success;
    };
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: "Protobowl",
        home: connected ? ProtobowlPage() : ErrorPage()
      )
    );
  }

}
