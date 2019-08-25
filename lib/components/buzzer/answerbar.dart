import 'package:flutter/material.dart';
import 'package:flutterbowl/server.dart';


class ProtobowlAnswerBar extends StatefulWidget {
  @override
  _ProtobowlAnswerBarState createState() => _ProtobowlAnswerBarState();
}
class _ProtobowlAnswerBarState extends State<ProtobowlAnswerBar> {
  final TextEditingController _answerController = TextEditingController();
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
                  controller: _answerController,
                  decoration: InputDecoration(
                      hintText: "Answer"),
                  onChanged: (text) => server.typingAnswer(text),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    server.pushAnswer(_answerController.text);
                  },
                ),
              ),
            ],
          ),
        )
    );
    }
}