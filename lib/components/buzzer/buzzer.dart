import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';

import 'answerbar.dart';
import 'chatbar.dart';

class ProtobowlBuzzer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BuzzViewmodel>(
      converter: (Store<AppState> store) => BuzzViewmodel(
        state: store.state.state,
        qid: store.state.question.qid,
        localBuzz: store.state.buzzed,
        chatting: store.state.chatting,
        callback: () => store.dispatch(BuzzAction())
      ),
      builder: (BuildContext context, BuzzViewmodel viewmodel) {
        // Chatting gets priority since it is not the default state
        if (viewmodel.chatting == true) {
          return ProtobowlChatBar();
        }
        else if (viewmodel.state == GameState.RUNNING) {
          // We are able to buzz
          return Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                    height: 48.0,
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(child: Icon(FontAwesomeIcons.bell, color: Colors.white),
                        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),),
                        Text("Buzz in", style: new TextStyle(fontSize: 18.0),),
                      ],
                    ),
                    onPressed: () {
                      viewmodel.callback();
                      server.buzz(viewmodel.qid);
                    }

                ),
              ),
            ],
          );
        } else if (viewmodel.state == GameState.FINISHED ||
            viewmodel.state == GameState.IDLE) {
          // The question has already been read, so the button will move to next question
          return Row(
            children: <Widget>[
              Expanded(
                child: new MaterialButton(
                  height: 48.0,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text("Next Question", style: new TextStyle(fontSize: 18.0),),
                  onPressed: () => server.next(),
                ),
              ),
            ],
          );
        } else if (viewmodel.state == GameState.BUZZED && viewmodel.localBuzz == false) {
          // Someone beat you to the buzzer.
          return Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                    height: 48.0,
                    disabledColor: Colors.black45,
                    disabledTextColor: Colors.white,
                    child: new Text("Buzz in", style: new TextStyle(fontSize: 18.0),),
                    onPressed: null
                ),
              ),
            ],
          );
        } else if (viewmodel.localBuzz == true) {
          // Render the answer bar
          return ProtobowlAnswerBar();
        }
        // I am leaving null here for debug purposes
        return null;
      }
    );
  }
}

class BuzzViewmodel {
  final GameState state;
  final String qid;
  final bool localBuzz;
  final bool chatting;
  final Function callback;
  BuzzViewmodel({this.state, this.qid, this.callback, this.localBuzz, this.chatting});
}