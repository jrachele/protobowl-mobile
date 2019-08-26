import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/components/drawer/drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtobowlLeaderboardViewModel>(
        converter: (Store<AppState> store) => ProtobowlLeaderboardViewModel(
            room: store.state.room, player: store.state.player),
        builder:
            (BuildContext context, ProtobowlLeaderboardViewModel viewModel) {
          return ExpansionTile(
            title: Text("Leaderboard", style: TextStyle(fontSize: 18)),
            leading: Icon(FontAwesomeIcons.list),
            children: <Widget>[
              Card(
                  margin: EdgeInsets.all(16),
                  child: Column (
                    children: _createUserWidgets(viewModel),
                  ),
              ) ,
            ],
          );
        });
  }
}

// This method returns a list of tiles containing individual information about
// users connected to this room
List<Widget> _createUserWidgets(ProtobowlLeaderboardViewModel viewModel) {
  List<Widget> children = List();
  List<dynamic> users = viewModel.room.users;
  if (users == null) return children;

  // Protobowl makes you calculate points client side, so we are taking care of that
  for (var user in users) {
    user["points"] = _calculateScore(
        viewModel.room.scoring, user["corrects"], user["wrongs"]);
    user["negs"] = _calculateNegs(user["wrongs"]);
  }
  // Sort the list in descending order
  users.sort((lhs, rhs) {
    return rhs["points"] - lhs["points"];
  });

  // Nesting a function to avoid having to copy and paste. The objective is to
  // populate the list with respect to online users first, then call the same
  // builder on the offline users to keep them separated for the user
  void _adduser(Map<String, dynamic> user) {
    children.add(ListTile(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            child: Text(
              " ${user["points"]} ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                backgroundColor: user["online_state"]
                    ? (viewModel.player.userID == user["id"]
                        ? Colors.green
                        : Colors.blue)
                    : Colors.black26,
              ),
            ),
//                        Icon(FontAwesomeIcons.portrait,
//                            color: user["online_state"] ? Colors.blue : Colors.black26
//                        ),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0)),
        Expanded(
          child: Container(
            child: Text("${user["name"]}",
                style: user["online_state"] ? _activeUser : _offlineUser,
                overflow: TextOverflow.fade,
                softWrap: false),
          ),
        ),
        Container(
            child: Text("Negs: ${user["negs"]}",
                style: user["online_state"] ? _activeUser : _offlineUser,
                overflow: TextOverflow.fade),
            margin: EdgeInsets.fromLTRB(16, 0, 0, 0))
      ],
    )));
  }

  for (var user in users.where((user) => user["online_state"])) {
    _adduser(user);
  }

  for (var user in users.where((user) => !user["online_state"])) {
    _adduser(user);
  }

  return children;
}

TextStyle _activeUser = TextStyle(
  fontSize: 16,
);

TextStyle _offlineUser = TextStyle(fontSize: 16, color: Colors.black26);

int _calculateScore(Map<String, dynamic> scoring, Map<String, dynamic> corrects,
    Map<String, dynamic> wrongs) {
  int score = 0;
  // Give points for correct answers
  score += (corrects["interrupt"] ?? 0) * scoring["interrupt"][0];
  score += (corrects["early"] ?? 0) * scoring["early"][0];
  score += (corrects["normal"] ?? 0) * scoring["normal"][0];

  // Subtract points for incorrect answers (the negative is included in the coefficient)
  score += (wrongs["interrupt"] ?? 0) * scoring["interrupt"][1];
  score += (wrongs["early"] ?? 0) * scoring["early"][1];
  score += (wrongs["normal"] ?? 0) * scoring["normal"][1];

  return score;
}

int _calculateNegs(Map<String, dynamic> wrongs) {
  return (wrongs["interrupt"] ?? 0) + (wrongs["early"] ?? 0);
}

class ProtobowlLeaderboardViewModel {
  final Room room;
  final Player player;

  ProtobowlLeaderboardViewModel({this.room, this.player});
}
