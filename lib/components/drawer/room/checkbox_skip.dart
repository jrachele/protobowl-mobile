import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckboxSkip extends StatefulWidget {
  @override
  _SkipState createState() => _SkipState();
}

class _SkipState extends State<CheckboxSkip> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SkipViewModel>(converter: (Store<AppState> store) {
      return SkipViewModel(allowSkipQuestions: store.state.room.allowSkipQuestions, lock: store.state.player.lock);
    }, builder: (BuildContext context, SkipViewModel viewModel) {
      return CheckboxListTile(
        title: Text("Allow skipping questions"), //    <-- label
        value: viewModel.allowSkipQuestions,
        onChanged: viewModel.lock ? null : (newValue) {
          setState(() {
            server.setSkipping(newValue);
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      );
    });
  }
}

class SkipViewModel {
  final bool allowSkipQuestions;
  final bool lock;

  SkipViewModel({this.allowSkipQuestions, this.lock});
}