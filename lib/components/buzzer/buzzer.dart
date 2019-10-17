import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutterbowl/server/server.dart';
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
            callback: () => store.dispatch(BuzzAction())),
        builder: (BuildContext context, BuzzViewmodel viewmodel) {
          // Chatting gets priority since it is not the default state
          if (viewmodel.chatting == true) {
            return ProtobowlChatBar();
          } else if (viewmodel.state == GameState.RUNNING) {
            // We are able to buzz
            return Container(
              margin: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  // Buzz button
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: FloatingActionButton.extended(
                          backgroundColor: Colors.red,
                          heroTag: "buzz",
                          icon: Icon(FontAwesomeIcons.bell),
                          label: Text("Buzz in", style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            viewmodel.callback();
                            server.buzz(viewmodel.qid);
                          }),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.black26,
                      heroTag: "nextDisabled",
                      disabledElevation: 0,
                      icon: Icon(FontAwesomeIcons.arrowCircleRight),
                      label: Text("Next"),
                      onPressed: null,
                    ),
                  )
                ],
              ),
            );
          } else if (viewmodel.state == GameState.FINISHED ||
              viewmodel.state == GameState.IDLE ||
              (viewmodel.state == GameState.BUZZED &&
                  viewmodel.localBuzz == false)) {
            // Someone beat you to the buzzer OR the question is over.
            return Container(
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Buzz button
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: FloatingActionButton.extended(
                        backgroundColor: Colors.black26,
                        heroTag: "buzzDisabled",
                        disabledElevation: 0,
                        icon: Icon(FontAwesomeIcons.bell),
                        label: Text("Buzz in", style: TextStyle(fontSize: 18)),
                        onPressed: null,
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: FloatingActionButton.extended(
                      icon: Icon(FontAwesomeIcons.arrowCircleRight),
                      heroTag: "next",
                      label: Text("Next"),
                      onPressed: server.next,
                    ),
                  )
                ],
              ),
            );
          } else if (viewmodel.localBuzz == true) {
            // Render the answer bar
            return ProtobowlAnswerBar();
          }
          // I am leaving null here for debug purposes
          return null;
        });
  }
}

class BuzzViewmodel {
  final GameState state;
  final String qid;
  final bool localBuzz;
  final bool chatting;
  final Function callback;
  BuzzViewmodel(
      {this.state, this.qid, this.callback, this.localBuzz, this.chatting});
}
