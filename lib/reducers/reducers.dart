import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';
import 'package:flutterbowl/reducers/reducer_question.dart';
import 'package:flutterbowl/reducers/reducer_user.dart';
import 'package:flutterbowl/reducers/reducer_questiontime.dart';
import 'package:flutterbowl/reducers/reducer_gamestate.dart';
import 'package:flutterbowl/reducers/reducer_room.dart';
import 'package:flutterbowl/reducers/reducer_buzzer.dart';
import 'package:flutterbowl/reducers/reducer_chatting.dart';
import 'package:flutterbowl/reducers/reducer_chatbox.dart';

// The entire appReducer will branch any action out so it may modify separate
// state-containing entities as needed
AppState appReducer(AppState state, action) {
  // If there is a room change action, the whole thing has to go initial
  if (action is RoomChangeAction) {
    return AppState.initial(rate: state.room.rate);
  }
  return AppState(
    state: gameStateReducer(state, action),
    question: questionReducer(state, action),
    player: playerReducer(state, action),
    room: roomReducer(state, action),
    questionTime: questionTimeReducer(state, action),
    buzzed: buzzedReducer(state, action),
    chatting: chattingReducer(state, action),
    chatbox: chatBoxReducer(state, action)
  );
}

