import 'package:flutter/material.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/components/drawer/drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

ExpansionTile LeaderboardView(ProtobowlDrawerViewModel viewModel) {
  List<Widget> children = List();
  List<dynamic> users = viewModel.room.users;

  // Protobowl makes you calculate points client side, so we are taking care of that
  for (var user in users) {
    user["points"] = _calculateScore(viewModel.room.scoring, user["corrects"], user["wrongs"]);
  }
  // Sort the list in descending order
  users.sort((lhs, rhs){
    return rhs["points"] - lhs["points"];
  });

  for (var user in users.where((user) => user["online_state"])) {
    children.add(
        Card(
          child: ListTile(
              title:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(FontAwesomeIcons.portrait, color: Colors.blue),
                  Text("${user["name"]}",
                      style: (viewModel.player.userID == user["id"]) ?
                      _currentUser : _activeUser),
                  Text("Pts: ${user["points"]}", style: _activeUser)
                ],
              )),
          borderOnForeground: true,
        )
    );
  }

  for (var user in users.where((user) => !user["online_state"])) {
    children.add(
        Card(
          child: ListTile(
              title:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(FontAwesomeIcons.portrait, color: Colors.black26),
                  Text("${user["name"]}", style: _offlineUser),
                  Text("Pts: ${user["points"]}", style: _offlineUser)
                ],
              )),
          borderOnForeground: true,
        )
    );
  }

  return ExpansionTile(
    title: Text("Leaderboard",
    style: TextStyle(
      fontSize: 18
    )),
    leading: Icon(
      FontAwesomeIcons.list
    ),
    children: children,
  );
}

TextStyle _activeUser = TextStyle(
  fontSize: 16,
);

TextStyle _currentUser = TextStyle(
  fontSize: 16,
  color: Colors.amber
);

TextStyle _offlineUser = TextStyle(
  fontSize: 16,
  color: Colors.black26
);

int _calculateScore(Map<String, dynamic> scoring, Map<String, dynamic> corrects, Map<String, dynamic> wrongs) {
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