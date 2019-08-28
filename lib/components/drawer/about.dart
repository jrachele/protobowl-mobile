import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:flutterbowl/models/models.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Icon(FontAwesomeIcons.solidQuestionCircle),
            margin: EdgeInsets.fromLTRB(0, 0, 32, 0),
          ),
          Expanded(
            child: Container(
              child: Text("About", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
      onTap: () => _asyncInputDialog(context),
    );
  }
}

Future<void> _asyncInputDialog(BuildContext context) async {
  String newName = '';
  return showDialog<String>(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('About Protobowl Mobile'),
        content: Text(
          "Protobowl.com is a website created in August 2012. It is a real time "
              "chatroom-style trivia application that pulls questions from "
              "popular Quizbowl tournaments.\nThis application was written by "
              "a separate person but tries to keep in the spirit of the "
              "web application. This application is 100% free and open source."
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
