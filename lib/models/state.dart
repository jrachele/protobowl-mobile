import 'package:meta/meta.dart';
import 'package:flutterbowl/models/models.dart';


enum GameState {  IDLE, RUNNING,
                  PAUSED, PROMPTED, BUZZED, FINISHED }

@immutable
class AppState {
  final GameState state;
  final Question question;
  final Room room;
  final Player player;
  final MessageWindow chatbox;
  final int questionTime;
  final bool buzzed;
  final bool chatting;

  AppState(
      { this.state,
        this.question,
        this.room,
        this.player,
        this.chatbox,
        this.questionTime,
        this.buzzed,
        this.chatting,
//        this.player = Player.blank,
//        this.room = Room.blank,
      });

  factory AppState.initial({int rate = 60}) {
    return AppState(
      state: GameState.IDLE,
      question: Question(),
      room: Room(
        allowMultipleBuzzes: true,
        allowPauseQuestions: true,
        allowSkipQuestions: true,
        rate: rate,
      ),
      player: Player(
        lock: false
      ),
      chatbox: MessageWindow(),
      questionTime: 0,
      buzzed: false,
      chatting: false
    );
  }

  @override
  String toString() {
    return "\nTime: $questionTime\nPlayer buzzed: $buzzed\n$state\n$question\n$room\n";
  }
}