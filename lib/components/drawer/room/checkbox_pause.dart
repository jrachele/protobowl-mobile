import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckboxPause extends StatefulWidget {
  @override
  _PauseState createState() => _PauseState();
}

class _PauseState extends State<CheckboxPause> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PauseViewModel>(converter: (Store<AppState> store) {
      return PauseViewModel(allowPauseQuestions: store.state.room.allowPauseQuestions, lock: store.state.player.lock);
    }, builder: (BuildContext context, PauseViewModel viewModel) {
      return CheckboxListTile(
        title: Text("Allow pausing questions"), //    <-- label
        value: viewModel.allowPauseQuestions,
        onChanged: viewModel.lock ? null : (newValue) {
          setState(() {
            server.setPausing(newValue);
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      );
    });
  }
}

class PauseViewModel {
  final bool allowPauseQuestions;
  final bool lock;

  PauseViewModel({this.allowPauseQuestions, this.lock});
}

