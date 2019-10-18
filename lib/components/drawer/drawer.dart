
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/models/models.dart';

import 'about.dart';
import 'leaderboard.dart';
import 'user.dart';
import 'package:flutterbowl/components/drawer/room/room.dart';

class ProtobowlDrawer extends StatelessWidget {
  String version;

  ProtobowlDrawer(this.version) {
    if (this.version == null) {
      this.version = "";
    } else {
      this.version = "\tv" + this.version;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 132,
              margin: EdgeInsets.zero,
              child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: <Widget>[
                      Text("Protobowl", style: TextStyle(fontSize: 36, color: Colors.white)),
                      Text("doing one thing and doing it acceptably well", style: TextStyle(fontSize: 12, color: Colors.white, fontStyle: FontStyle.italic)),
//                      Spacer(),
                      Text("protobowl-mobile$version", style: TextStyle(fontSize: 11, color: Colors.white30, fontStyle: FontStyle.italic)),
//                      Text("github.com/jrachele", style: TextStyle(fontSize: 12, color: Colors.white30, fontStyle: FontStyle.italic)),
                    ],
                  )
              ),
            ),
            UserView(),
            RoomView(),
            LeaderboardView(),
          ],
        )
    );
  }

}

