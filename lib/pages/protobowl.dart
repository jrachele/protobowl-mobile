import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/components/appbar.dart';
import 'package:flutterbowl/components/questionreader.dart';
import 'package:flutterbowl/components/buzzer/buzzer.dart';

class ProtobowlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: ProtobowlAppBar(),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ProtobowlQuestionReader(),
              ProtobowlBuzzer()
        ]
        )
    );
  }
}
//
//class ProtobowlViewmodel {
//  final GameState gameState;
//  final Question question;
//
//  ProtobowlViewmodel({ this.gameState, this.question });
//
//  factory ProtobowlViewmodel.create(Store<AppState> store) {
//    return ProtobowlViewmodel(
//      gameState: store.state.state,
//      question: store.state.question,
//    );
//  }
//}
