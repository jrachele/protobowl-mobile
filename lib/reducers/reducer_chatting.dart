import 'dart:convert';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutterbowl/server.dart';
import 'package:flutterbowl/models/models.dart';
import 'package:flutterbowl/actions/actions.dart';


bool chattingReducer(AppState prev, dynamic action) {
  if (action is ChatAction) {
    // You are forbidden from chatting and buzzing simultaneously
    return !prev.buzzed;
  } else if (action is FinishChatAction) {
    return false;
  }
  return prev.chatting;
}
