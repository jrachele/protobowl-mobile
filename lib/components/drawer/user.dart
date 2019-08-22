import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/components/drawer/drawer.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Player>(
      converter: (Store<AppState> store) => store.state.player,
      builder: (BuildContext context, Player player) =>
          ListTile(
              title:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(FontAwesomeIcons.passport),
                  Text("${player.name}", style: TextStyle(fontSize: 18)),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.pen,
                        size: 16),
                    onPressed: () async {
                      server.setName(await _asyncInputDialog(context));
                    },
                  )
//          Text("${user["name"]}",
//              style: (viewModel.player.userID == user["id"]) ?
//              _currentUser : _activeUser),
//          Text("Pts: ${user["points"]}", style: _activeUser)
                ],
              )
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
        title: Text('Change player name'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      hintText: 'New player name'),
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
