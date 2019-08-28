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
    return StoreConnector<AppState, bool>(converter: (Store<AppState> store) {
      return store.state.room.allowSkipQuestions ?? true;
    }, builder: (BuildContext context, bool allowSkipping) {
      return CheckboxListTile(
        title: Text("Allow skipping questions"), //    <-- label
        value: allowSkipping,
        onChanged: (newValue) {
          setState(() {
            server.setSkipping(newValue);
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      );
    });
  }
}
