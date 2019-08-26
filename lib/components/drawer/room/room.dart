import 'package:flutter/material.dart';
import 'package:flutterbowl/components/drawer/room/change_rate.dart';
import 'package:flutterbowl/components/drawer/room/checkbox_multiplebuzz.dart';
import 'package:flutterbowl/components/drawer/room/checkbox_skip.dart';
import 'package:flutterbowl/components/drawer/room/checkbox_pause.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterbowl/server.dart';

import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';
import 'package:flutterbowl/components/drawer/drawer.dart';

class RoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtobowlRoomViewModel>(
      converter: (Store<AppState> store) => ProtobowlRoomViewModel(
          room: store.state.room,
          roomChange: () {
            // When changing rooms, a new socket has to be fetched
            // otherwise Protobowl will count you as a zombie
            store.dispatch(RoomChangeAction());
            server.channel.stream.listen((packet) {
              // Always ping when receiving a packet
              server.ping();
              debugPrint(packet);
              store.dispatch(ReceivePacketAction(packet));
            });
          }),
      builder: (BuildContext context, ProtobowlRoomViewModel viewModel) =>
          ExpansionTile(
        title: Text("Room", style: TextStyle(fontSize: 18)),
        leading: Icon(
          FontAwesomeIcons.doorOpen,
        ),
        children: <Widget>[
          Card(
              margin: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  // Change rooms
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Icon(FontAwesomeIcons.users),
                        margin: EdgeInsets.fromLTRB(8, 0, 32, 0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text("${viewModel.room.name}",
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.fade,
                              softWrap: false),
                        ),
                      ),
                      Container(
                          child: IconButton(
                            icon: Icon(FontAwesomeIcons.pen, size: 16),
                            onPressed: () async {
                              server.channel.sink.close();
                              server.channel = await server.getChannel();
                              server.joinRoom(await _asyncInputDialog(context));
                              viewModel.roomChange();
                            },
                          ),
                          margin: EdgeInsets.fromLTRB(32, 0, 0, 0))
                    ],
                  ),
                  Divider(),
                  RateSlider(),
                  Divider(),
                  CheckboxMultipleBuzz(),
                  CheckboxSkip(),
                  CheckboxPause(),
                  Divider(),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 16),
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.redAccent,
                      onPressed: server.resetScore,
                      icon: Icon(FontAwesomeIcons.trash),
                      label: Text("Reset my score"),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

Future<String> _asyncInputDialog(BuildContext context) async {
  String newName = '';
  return showDialog<String>(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change room name'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(hintText: 'New room name'),
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

class ProtobowlRoomViewModel {
  final Room room;
  final Function roomChange;

  ProtobowlRoomViewModel({this.room, this.roomChange});
}
