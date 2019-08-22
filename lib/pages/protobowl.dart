import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/server.dart';
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


class _ProtobowlPageState extends State<ProtobowlPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: ProtobowlAppBar(),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProtobowlProgressBar(),
              ProtobowlQuestionReader(),
              ProtobowlBuzzer()
        ]
        ),
      drawer: ProtobowlDrawer()
    );
  }

  @override
  void dispose() {
    server.channel.sink.close();
    super.dispose();
  }
}
