import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';

class ProtobowlAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HtmlText>(
      converter: (Store<AppState> store) {
        return store.state.state == GameState.FINISHED ?
        _formatProtobowlAnswer(store.state.question.answer) :
        _formatProtobowlAnswer("${store.state.question.category} | ${store.state.question.difficulty}");
      },
      builder: (BuildContext context, HtmlText appBarText) {
        return AppBar(
          title: appBarText,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_right),
              tooltip: 'Next Question',
              onPressed: server.next,
            )
          ],
        );
      }
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);

}


HtmlText _formatProtobowlAnswer(String answer) {
  answer = answer.split("[")[0]
      .split("(")[0]
      .replaceAll("{", "<b><i>")
      .replaceAll("}", "</i></b>");
  return HtmlText(data: answer);
}
