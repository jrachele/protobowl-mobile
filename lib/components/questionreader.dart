import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';

class ProtobowlQuestionReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtobowlQuestionReaderViewModel>(
        converter: (Store<AppState> store) {
                  return ProtobowlQuestionReaderViewModel(
                    question: store.state.question.question,
                    timings: store.state.question.timings,
                    beginTime: store.state.question.beginTime,
                    currentTime: store.state.questionTime,
                    endTime: store.state.question.endTime,
                    rate: store.state.room.rate
                  );
        },
        builder: (BuildContext context, ProtobowlQuestionReaderViewModel viewModel) {
          return
            Expanded(
              child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: new Text( // answer text
                                  viewModel.calculateVisibleWords(),
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

class ProtobowlQuestionReaderViewModel {
  final String question;
  final List<dynamic> timings;
  final int beginTime;
  final int currentTime;
  final int endTime;
  final int rate;

  ProtobowlQuestionReaderViewModel({ this.question, this.timings, this.beginTime, this.currentTime, this.endTime, this.rate});

  String calculateVisibleWords() {
    if (timings == null) return "";
    // Walk up the timings until we are at the index of the word in the question
    int i = 0;
    for (int t = beginTime; i < timings.length && t < currentTime; i++) {
      t += (timings[i] as int)*rate;
    }
    return question.split(" ").sublist(0, i).join(" ");
  }
}