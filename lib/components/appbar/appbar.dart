import 'package:flutter/material.dart';
import 'package:flutterbowl/actions/actions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html_view/flutter_html_text.dart';
import 'package:flutterbowl/server/server.dart';
import 'package:flutterbowl/models/models.dart';

class ProtobowlAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtobowlAppBarViewModel>(
      converter: (Store<AppState> store) {
        return ProtobowlAppBarViewModel(
            appBarText: store.state.state == GameState.FINISHED ?
              _formatProtobowlAnswer(store.state.question.answer) :
              _formatProtobowlAnswer("${store.state.question.category} | ${store.state.question.difficulty}"),
            chatAction: () => store.dispatch(ClientChatAction())
        );
      },
      builder: (BuildContext context, ProtobowlAppBarViewModel viewModel) {
        return AppBar(
          title: viewModel.appBarText,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.chat_bubble),
              tooltip: 'Chat',
              onPressed: viewModel.chatAction,
            ),],
            );
      }
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);

}


HtmlText _formatProtobowlAnswer(String answer) {
  if (answer == null) return null;
  answer = answer.split("[")[0]
      .split("(")[0]
      .replaceAll("{", "<b><i>")
      .replaceAll("}", "</i></b>");
  return HtmlText(data: answer);
}

class ProtobowlAppBarViewModel {
  final HtmlText appBarText;
  final Function chatAction;

  ProtobowlAppBarViewModel({this.appBarText, this.chatAction});
}