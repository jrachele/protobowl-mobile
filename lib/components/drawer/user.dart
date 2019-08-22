import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/components/drawer/drawer.dart';

ExpansionTile UserView(ProtobowlDrawerViewModel viewModel) {
  return ExpansionTile(
    initiallyExpanded: true,
    title: Text("Player",
        style: TextStyle(
            fontSize: 18
        )),
    leading: Icon(
        FontAwesomeIcons.user,
    ),
    children: <Widget>[

    ],
  );
}

