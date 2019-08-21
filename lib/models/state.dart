import 'package:meta/meta.dart';
import 'package:flutterbowl/models/models.dart';


enum GameState {  IDLE, RUNNING,
                  PAUSED, PROMPTED, BUZZED, FINISHED }

@immutable
class AppState {
  final GameState state;
  final Question question;
  final Room room;
//  final Player player;
//  final Room room;

  final int questionTime;

  AppState(
      { this.state,
        this.question,
        this.room,
        this.questionTime
//        this.player = Player.blank,
//        this.room = Room.blank,
      });

  factory AppState.initial() {
    return AppState(
      state: GameState.IDLE,
      question: Question(),
      room: Room(
        rate: 60
      ),
      questionTime: 0
    );
  }

  @override
  String toString() {
    return "\nTime: $questionTime\n$state\n$question\n$room\n";
  }
}