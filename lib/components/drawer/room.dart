import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/components/drawer/drawer.dart';

ExpansionTile RoomView(Room room) {
  return ExpansionTile(
    title: Text("Room",
        style: TextStyle(
            fontSize: 18
        )),
    leading: Icon(
        FontAwesomeIcons.doorOpen,
    ),
    children: <Widget>[

    ],
  );
}

