import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/reducers/reducer_question.dart';
import 'package:flutterbowl/reducers/reducer_questiontime.dart';
import 'package:flutterbowl/reducers/reducer_gamestate.dart';
import 'package:flutterbowl/reducers/reducer_room.dart';
import 'package:flutterbowl/reducers/reducer_buzzer.dart';

// The entire appReducer will branch any action out so it may modify separate
// state-containing entities as needed
AppState appReducer(AppState state, action) {
  return AppState(
    state: gameStateReducer(state, action),
    question: questionsReducer(state.question, action),
    room: roomReducer(state, action),
    questionTime: questionTimeReducer(state, action),
    buzzed: buzzedReducer(state, action)
  );
}

