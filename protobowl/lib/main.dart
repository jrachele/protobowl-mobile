import 'package:flutter/material.dart';
import 'dart:async';
import 'sockethandler.dart';


void main() {
  runApp(new ProtobowlApp());
}

class ProtobowlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Protobowl",
      debugShowCheckedModeBanner: false,
      home: new ProtobowlHome(),
    );
  }
}

class ProtobowlHome extends StatefulWidget {
  @override
  State createState() => new ProtobowlHomeState();
}

class ProtobowlHomeState extends State<ProtobowlHome>{
  // Set up the text editing controller for the text box
  final TextEditingController _answerController = new TextEditingController();

 Timer timer;
 ProtobowlHomeState() {
   timer = new Timer.periodic(new Duration(milliseconds: rate != null ? rate : 60), callback);
 }

 int counter = 0;
 int wordIndex = 0;

 void callback(Timer timer) {
   // This is kind of a hack way of allowing an asynchronous callback every 100 milliseconds or so 
   // to check if the question has expired


   if (state == GameState.RUNNING || state == GameState.NEWQUESTION) {
     setState(() { 
       if (sockTime != null && endTime != null && rate != null) {
          sockTime += rate; // default is 60 for each
          print("Syllable array length: ${syllables.length}");
          print("Question array length: ${question.length}");
          if (!done) { // question reader 
            counter++; // count each syllable 
            if (syllables[wordIndex] == counter)  {
              questionText += question[wordIndex] + " "; 
              wordIndex++;
              counter = 0;
            }
            if (wordIndex == syllables.length) {
              wordIndex = 0;
              counter = 0;
              done = true;
            }
          }
          
          print("Time remaining: ${(endTime - sockTime) / 1000}");

          if (sockTime < endTime) {
            state = GameState.RUNNING;
          } else {
            // question is over
            state = GameState.IDLE;
            showQuestion();
            wordIndex = 0;
            counter = 0;
          }
       }
       
     });
    }
 }
  @override
  void initState() {
    getChannel().then((ch) {
      setState((){
        channel = ch;
        joinRoom("bot-testing");
        setName("Protobowl Flutter");
        next();
      });
    });
    super.initState();
  }

  FocusNode focus = new FocusNode();
  
  Widget _buildAnswerBar() {
    if (buzzed && state != GameState.RUNNING) {
      return new Container(
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _answerController,
                    decoration: new InputDecoration(
                        hintText: "Answer"),
                    onChanged: (text) => _typing(),
                    focusNode: focus,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () => _answer(),
                  ),
                ),
              ],
            ),
          )
      );
    } else {
      if (state == null || state == GameState.IDLE) {
        return new Container(
            child: new Row (
                children: <Widget>[
                  new Expanded(
                    child: new MaterialButton(
                      height: 48.0,
                      color: Colors.green,
                      textColor: Colors.white,
                      child: new Text(answer != null ? format(answer) : "Next Question", style: new TextStyle(fontSize: 18.0),),
                      onPressed: () => _next(),
                    ),
                  ),
                ]
            )
        );
      } else {
        // buzz button
        return new Container(
            child: new Row (
                children: <Widget>[
                  new Expanded(
                    child: new MaterialButton(
                      height: 48.0,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: new Text("Buzz in", style: new TextStyle(fontSize: 18.0),),
                      onPressed: () {
                        _buzz();
                      }
                    ),
                  ),
                ]
            )
        );
      }
    }

  }


  void _answer() {
    pushAnswer(_answerController.text);
    if (state != GameState.BUZZED) { // if not prompt
        _answerController.clear();
        setState(() {
        buzzed = false;
        });
    }
    
  }

  // typing
  void _typing() {
    if (channel != null) {
      String answer = '5:::{"name":"guess","args":[{"text":"'
          '${_answerController.text}","done":false},null]}';
      channel.sink.add(answer);
    }
  }

  void _buzz(){
    if (state == GameState.RUNNING || state == GameState.NEWQUESTION) {
      setState(() {
        
        if (!buzzed) {
          buzzed = true;
        } else {
          buzzed = false;
        }

        buzz();
        _answerController.clear();
        FocusScope.of(context).requestFocus(focus);
        // state = GameState.BUZZED;
      });
      
    }
  }

  void _next(){
    setState(() {
      next();
    });
  }

  void updateAppBar() {
    if (room != null && category != null) {
      appBarText = "$room » $category";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: channel?.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint(snapshot.data + "\n\n\n");
            updateData(snapshot.data);
            updateAppBar();
            return new Scaffold(
                appBar: new AppBar(
                  title: new Text(appBarText),
                  actions: <Widget>[
                    new IconButton(
                      icon: new Icon(Icons.arrow_right),
                      tooltip: 'Next Question',
                      onPressed: _next,
                    )
                  ],),
                body: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new LinearProgressIndicator(
                        value: (sockTime != null && endTime != null) ? (endTime - sockTime /endTime) : 0.0
                    ),
                    new Expanded(
                      child: new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: channel == null ?
                          new Container()
                              : questionContainer()
                      ),
                    ),
                    _buildAnswerBar(),
                  ],
                )
            );
          }
          return new Container();
        }
    );
  }


  // easiest as a function
  Container questionContainer() {
    // updateAppBarText();
    return new Container(
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: (question != null && answer != null) ?
//              Scaffold.of(context).showSnackBar(new SnackBar(
//                  content: new Text(answer)
//              )),
          new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Text( // answer text
                  questionText,
                  style: new TextStyle(fontSize: 18.0)
              )
          )

              : new Container(),


        )
    );
  }

  @override
  void dispose() {
    if (channel != null) channel.sink.close();
    super.dispose();
  }
}