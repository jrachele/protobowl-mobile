import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';

class ProtobowlBuzzer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BuzzViewmodel>(
      converter: (Store<AppState> store) => BuzzViewmodel(
        state: store.state.state,
        qid: store.state.question.qid
      ),
      builder: (BuildContext context, BuzzViewmodel viewmodel) {
        if (viewmodel.state == GameState.RUNNING) {
          return Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                    height: 48.0,
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text("Buzz in", style: new TextStyle(fontSize: 18.0),),
                    onPressed: () => server.buzz(viewmodel.qid),
                ),
              ),
            ],
          );
        } else if (viewmodel.state == GameState.FINISHED ||
            viewmodel.state == GameState.IDLE) {
          return Row(
            children: <Widget>[
              Expanded(
                child: new MaterialButton(
                  height: 48.0,
                  color: Colors.green,
                  textColor: Colors.white,
                  child: new Text("Next Question", style: new TextStyle(fontSize: 18.0),),
                  onPressed: () => server.next(),
                ),
              ),
            ],
          );
        }
        return null;
      }
    );
  }
}

class BuzzViewmodel {
  final GameState state;
  final String qid;
  BuzzViewmodel({this.state, this.qid});
}