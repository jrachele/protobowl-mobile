import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterbowl/server.dart';

import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/components/drawer/drawer.dart';

class RoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Room>(
      converter: (Store<AppState> store) => store.state.room,
      builder: (BuildContext context, Room room) =>
        ExpansionTile(
        title: Text("Room",
        style: TextStyle(
            fontSize: 18
        )),
        leading: Icon(
        FontAwesomeIcons.doorOpen,
        ),
        children: <Widget>[
          ListTile(
              title:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(child: Icon(FontAwesomeIcons.passport),
                    margin: EdgeInsets.fromLTRB(0, 0, 32, 0),),
                  Expanded(
                    child: Container(
                      child: Text("${room.name}", style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.fade,
                          softWrap: false),
                    ),
                  ),
                  Container(
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.pen,
                            size: 16),
                        onPressed: () async {
                          server.joinRoom(await _asyncInputDialog(context));
                        },
                      ),
                      margin: EdgeInsets.fromLTRB(32, 0, 0, 0)
                  )
                ],
              )
          ),

        ],
        ),
        );
  }

}

Future<String> _asyncInputDialog(BuildContext context) async {
  String newName = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change room name'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      hintText: 'New room name'),
                  onChanged: (value) {
                    newName = value;
                  },
                ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(newName);
            },
          ),
        ],
      );
    },
  );
}
