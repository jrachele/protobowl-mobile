import 'package:flutter/material.dart';
import 'package:flutterbowl/server/server.dart';


class ProtobowlChatBar extends StatefulWidget {
  @override
  _ProtobowlChatBarState createState() => _ProtobowlChatBarState();
}
class _ProtobowlChatBarState extends State<ProtobowlChatBar> {
  final TextEditingController _chatController = TextEditingController();

  String session;

  @override
  initState() {
    // We are overriding this to generate a specific session for the chat message.
    // This is kind of hacky but it works in this case.
    session = server.randomString(10);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              new Flexible(
                child: TextField(
                  autofocus: true,
                  controller: _chatController,
                  decoration: InputDecoration(
                      hintText: "Chat"),
                  onChanged: (text) => server.typingMessage(text, session, false),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    server.typingMessage(_chatController.text, session, true);
                    server.finishChat();
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
