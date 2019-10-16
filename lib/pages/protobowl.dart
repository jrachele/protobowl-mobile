import 'package:flutter/material.dart';
import 'package:flutterbowl/components/buzzer/next.dart';
import 'package:flutterbowl/components/messaging/messaging.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/components/appbar/appbar.dart';
import 'package:flutterbowl/components/appbar/progressbar.dart';
import 'package:flutterbowl/components/questionreader.dart';
import 'package:flutterbowl/components/drawer/drawer.dart';
import 'package:flutterbowl/components/buzzer/buzzer.dart';

class ProtobowlPage extends StatefulWidget {
  @override
  _ProtobowlPageState createState() => _ProtobowlPageState();
}


class _ProtobowlPageState extends State<ProtobowlPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: ProtobowlAppBar(),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProtobowlProgressBar(),
              ProtobowlQuestionReader(),
              ProtobowlMessageWindow(),
              ProtobowlBuzzer()
        ]
        ),
      drawer: ProtobowlDrawer()
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  // This ensures that the connection to the server is broken when the app is closed
  @override
  void dispose() {
//    server.channel.sink.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This prevents the user being stuck with no server connection
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
//      server.channel.sink.close();
//      server.channel = await server.getChannel();
//      server.refreshServer();
    }
  }
}
