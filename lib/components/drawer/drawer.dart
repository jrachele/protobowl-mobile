
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/models/models.dart';

import 'about.dart';
import 'leaderboard.dart';
import 'user.dart';
import 'package:flutterbowl/components/drawer/room/room.dart';

class ProtobowlDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 130,
              margin: EdgeInsets.zero,
              child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: <Widget>[
                      Text("Protobowl", style: TextStyle(fontSize: 36, color: Colors.white)),
                      Text("doing one thing and doing it acceptably well", style: TextStyle(fontSize: 12, color: Colors.white, fontStyle: FontStyle.italic)),
                    ],
                  )
              ),
            ),
            UserView(),
            RoomView(),
            LeaderboardView(),
//            Spacer(),
          ],
        )
    );
  }

}

