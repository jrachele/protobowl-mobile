import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';

class ProtobowlChatBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtobowlChatBoxViewModel>(
        converter: (Store<AppState> store) {
          return ProtobowlChatBoxViewModel(
              question: store.state.question.question,
              timings: store.state.question.timings,
              beginTime: store.state.question.beginTime,
              currentTime: store.state.questionTime,
              endTime: store.state.question.endTime,
              rate: store.state.room.rate
          );
        },
        builder: (BuildContext context, ProtobowlChatBoxViewModel viewModel) {
          return
            Expanded(
              child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: new Text(
                                  "",
                                  style: new TextStyle(fontSize: 18.0)
                              )
                          )


                      )
                  )
              ),
            );
        }
    );
  }
}

class ProtobowlChatBoxViewModel {
  final String question;
  final List<dynamic> timings;
  final int beginTime;
  final int currentTime;
  final int endTime;
  final int rate;

  ProtobowlChatBoxViewModel({ this.question, this.timings, this.beginTime, this.currentTime, this.endTime, this.rate});

}
