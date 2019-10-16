import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/actions/actions.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/reducers/reducers.dart';
import 'package:flutterbowl/pages/protobowl.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'server/socket.dart';

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
  server.socket = Socket();
  server.socket.io(server.server);
  server.socket.onConnected(() => server.joinRoom(room));
  runApp(new ProtobowlApp());
}


class ProtobowlApp extends StatelessWidget {
  // Create the store, which is an immutable representation of our app state
  final store = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
//    middleware: [LoggingMiddleware.printer()]
  );

//  final TextEditingController answerController = TextEditingController();

  ProtobowlApp() {
    // Mess with the Feng-shui of Redux because we are forced to
//    server.channel.stream.listen((packet){
//      // Always ping when receiving a packet
//      server.ping();
//      debugPrint(packet);
//      store.dispatch(ReceivePacketAction(packet));
//    });
    
    server.timerCallback = (Timer timer) => store.dispatch(TickAction());
    server.timer =
        Timer.periodic(Duration(milliseconds: 60), server.timerCallback);
    server.finishChat = () => store.dispatch(FinishChatAction());
    server.refreshServer = ({String room}) {
      // When changing rooms, a new socket has to be fetched
      // otherwise Protobowl will count you as a zombie
      if (room != null) {
        server.joinRoom(room);
      } else {
        server.joinRoom(store.state.room.name);
      }
      store.dispatch(RoomChangeAction());
//      server.channel.stream.listen((packet) {
//        // Always ping when receiving a packet
//        server.ping();
//        debugPrint(packet);
//        store.dispatch(ReceivePacketAction(packet));
//      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: "Protobowl",
        home: ProtobowlPage()
      )
    );
  }

}
