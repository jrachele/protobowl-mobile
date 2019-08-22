
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterbowl/models/models.dart';

import 'leaderboard.dart';

class ProtobowlDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtobowlDrawerViewModel>(
      converter: (Store<AppState> store) => ProtobowlDrawerViewModel(
        room: store.state.room,
        player: store.state.player
      ),
      builder: (BuildContext context, ProtobowlDrawerViewModel viewModel) {
        return Drawer(
          child: ListView(
            children: <Widget>[
              LeaderboardView(viewModel.room),
            ],
          )
        );
      }

    );
  }

}

class ProtobowlDrawerViewModel {
  final Room room;
  final Player player;

  ProtobowlDrawerViewModel({this.room, this.player});
}