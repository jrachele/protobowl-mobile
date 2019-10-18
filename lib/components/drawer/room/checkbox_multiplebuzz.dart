import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckboxMultipleBuzz extends StatefulWidget {
  @override
  _MultipleBuzzState createState() => _MultipleBuzzState();
}

class _MultipleBuzzState extends State<CheckboxMultipleBuzz> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MultipleBuzzViewModel>(
        converter: (Store<AppState> store) {
          return MultipleBuzzViewModel(
              allowMultipleBuzzes: store.state.room.allowMultipleBuzzes,
              lock: store.state.player.lock);
    },
        builder: (BuildContext context, MultipleBuzzViewModel viewModel) {
      return CheckboxListTile(
        title: Text("Allow multiple buzzes"), //    <-- label
        value: viewModel.allowMultipleBuzzes,
        onChanged: viewModel.lock ? null : (newValue) {
          setState(() {
            server.setMultipleBuzzes(newValue);
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      );
    });
  }
}

class MultipleBuzzViewModel {
  final bool allowMultipleBuzzes;
  final bool lock;
  MultipleBuzzViewModel({this.allowMultipleBuzzes, this.lock});
}
