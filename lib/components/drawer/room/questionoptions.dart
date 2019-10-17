import 'package:flutterbowl/models/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutterbowl/server/server.dart';

class QuestionOptions extends StatefulWidget {
  @override
  _QuestionOptionsState createState() => _QuestionOptionsState();
}

class _QuestionOptionsState extends State<QuestionOptions> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, QuestionOptionsViewModel>(
        converter: (Store<AppState> store) => QuestionOptionsViewModel(
              category: store.state.room.category,
              difficulty: store.state.room.difficulty,
            ),
        builder: (BuildContext context, QuestionOptionsViewModel viewModel) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Icon(FontAwesomeIcons.bullseye),
                margin: EdgeInsets.fromLTRB(12, 0, 8, 0),
              ),
              Container(
                  child: DropdownButton<String>(
                      value: viewModel.difficulty != ""
                          ? viewModel.difficulty
                          : "Any",
                      items: <String>["Any", "Open", "College", "HS", "MS"]
                          .map<DropdownMenuItem<String>>((String difficulty) =>
                              DropdownMenuItem<String>(
                                  value: difficulty, child: Text(difficulty)))
                          .toList(),
                      onChanged: (String difficulty) {
                        setState(() {
                          debugPrint("Difficulty: $difficulty");
                          server.setDifficulty(
                              difficulty != "Any" ? difficulty : "");
                        });
                      })),
              Container(
                  child: DropdownButton<String>(
                      value: viewModel.category != ""
                          ? viewModel.category
                          : "Everything",
                      items: <String>["Everything", "custom", "Current Events", "Fine Arts", "Geography", "History", "Literature", "Mythology", "Philosophy", "Religion", "Science", "Social Science", "Trash"]
                          .map<DropdownMenuItem<String>>((String category) =>
                              DropdownMenuItem<String>(
                                  value: category, child: Text(category)))
                          .toList(),
                      onChanged: (String category) {
                        setState(() {
                          debugPrint("Category: $category");
                          server.setCategory(
                              category != "Everything" ? category : "");
                        });
                      }),
                  margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
          )
          ],
          );
        });
  }
}

class QuestionOptionsViewModel {
  final String category;
  final String difficulty;
  QuestionOptionsViewModel({this.category, this.difficulty});
}
