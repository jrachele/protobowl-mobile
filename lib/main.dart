import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/actions/actions.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/reducers/reducers.dart';
import 'package:flutterbowl/pages/protobowl.dart';
import 'package:flutterbowl/server.dart';

void main() async {
  // Initialize the server and get the channel asynchronously
  server.channel = await server.getChannel();
  server.setName("billy");
  server.joinRoom("flutterbowl");
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
    server.channel.stream.listen((packet){
      // Always ping when receiving a packet
      server.ping();
      debugPrint(packet);
      store.dispatch(ReceivePacketAction(packet));
    });
    server.timerCallback = (Timer timer) => store.dispatch(TickAction());
    server.timer =
        Timer.periodic(Duration(milliseconds: 60), server.timerCallback);
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