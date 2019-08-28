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
    return StoreConnector<AppState, bool>(converter: (Store<AppState> store) {
      return store.state.room.allowPauseQuestions ?? true;
    }, builder: (BuildContext context, bool allowPausing) {
      return CheckboxListTile(
        title: Text("Allow pausing questions"), //    <-- label
        value: allowPausing,
        onChanged: (newValue) {
          setState(() {
            server.setPausing(newValue);
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      );
    });
  }
}
