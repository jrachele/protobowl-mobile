
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/models/models.dart';

class ProtobowlProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtobowlProgressBarViewModel>(
      converter: (Store<AppState> store) => ProtobowlProgressBarViewModel(
        beginTime: store.state.question.beginTime,
        currentTime: store.state.questionTime,
        endTime: store.state.question.endTime
      ),
      builder: (BuildContext context, ProtobowlProgressBarViewModel viewModel) {
        double value = 0;
        if (viewModel.currentTime != null && viewModel.endTime != null && viewModel.beginTime != null ) {
          if (viewModel.endTime - viewModel.beginTime == 0) value = 0;
          else
            value = (viewModel.currentTime - viewModel.beginTime) / (viewModel.endTime - viewModel.beginTime);
        }
        return LinearProgressIndicator(
          value: value,
        );
      }
    );
  }

}

class ProtobowlProgressBarViewModel {
  final int beginTime;
  final int currentTime;
  final int endTime;

  ProtobowlProgressBarViewModel({this.beginTime, this.currentTime, this.endTime});
}