import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';
import 'package:flutterbowl/reducers/reducer_question.dart';
import 'package:flutterbowl/reducers/reducer_player.dart';
import 'package:flutterbowl/reducers/reducer_questiontime.dart';
import 'package:flutterbowl/reducers/reducer_gamestate.dart';
import 'package:flutterbowl/reducers/reducer_room.dart';
import 'package:flutterbowl/reducers/reducer_buzzer.dart';
import 'package:flutterbowl/reducers/reducer_chatbox.dart';

// The entire appReducer will branch any action out so it may modify separate
// state-containing entities as needed
AppState appReducer(AppState state, action) {
  // If there is a room change action, the whole thing has to go initial
  if (action is RoomChangeAction) {
    return AppState.initial();
  }
  return AppState(
    state: gameStateReducer(state, action),
    question: questionsReducer(state.question, action),
    player: playerReducer(state.player, action),
    room: roomReducer(state, action),
    questionTime: questionTimeReducer(state, action),
    buzzed: buzzedReducer(state, action),
    chatbox: chatBoxReducer(state, action)
  );
}

