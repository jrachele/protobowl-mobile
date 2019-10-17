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
    return StoreConnector<AppState, bool>(converter: (Store<AppState> store) {
      return store.state.room.allowMultipleBuzzes ?? true;
    }, builder: (BuildContext context, bool allowMultipleBuzzes) {
      return CheckboxListTile(
        title: Text("Allow multiple buzzes"), //    <-- label
        value: allowMultipleBuzzes,
        onChanged: (newValue) {
          setState(() {
            server.setMultipleBuzzes(newValue);
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      );
    });
  }
}
