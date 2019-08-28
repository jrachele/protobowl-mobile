import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:flutterbowl/models/models.dart';

class ProtobowlMessageWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MessageWindow>(
        converter: (Store<AppState> store) {
          return store.state.chatbox;
        },
        builder: (BuildContext context, MessageWindow chatbox) {
          return Expanded(
              child: new Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    child: new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                          children: _parseMessageWindow(chatbox)),
                    ),


                  )
              ),
            flex: 1,
          );
        }
        );

  }
}

List<Widget> _parseMessageWindow(MessageWindow window) {
  if (window == null) return List();
  LinkedHashMap<String, Message> messages = window.messages;
  if (messages == null) return List();
  List<Widget> children = List<Widget>();
  Icon _determineIcon(Message message) {
    if (message is BuzzMessage) {
      // Show the prompt icon, but only when the question is incomplete
      if (message.prompt != null && message.prompt == true && !message.complete) {
        return Icon(
            FontAwesomeIcons.questionCircle,
            color: Colors.black26
        );
      }
      if (message.complete) {
        if (message.correct) {
          return Icon(
              FontAwesomeIcons.checkCircle,
              color: message.early ? Colors.black26 : Colors.green
          );
        } else {
          return Icon(
            FontAwesomeIcons.timesCircle,
            color: Colors.orange,
          );
        }
      } else {
        return Icon(
            FontAwesomeIcons.bell,
            color: message.early ? Colors.black26 : Colors.red
        );
      }
    } else if (message is LogMessage) {
      return Icon(
        FontAwesomeIcons.asterisk,
        color: Colors.black26,
      );
    } else {
      return Icon(
          FontAwesomeIcons.commentDots,
          color: Colors.black26
      );
    }
  }

    messages.forEach((String string, Message message) {
      // Only show non-empty messages
      if (!(message.message.isEmpty && message.complete && message is! BuzzMessage)) {
        children.insert(0,
            Card(
                child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: _determineIcon(message),
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0)
                        ),
                        Container(
                            child: Text("${message.name}",
                                style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0)
                        ),
                        Expanded(
                          child: Container(
                            child: message.message.isNotEmpty ?
                            Text("${message.message}") : Text("(no answer)", style: TextStyle(fontStyle: FontStyle.italic)),
                          ),
                        ),

                      ],
                    )
                )
            )
        );
      }
  });
  return children;
}