import 'dart:collection';

class MessageWindow {
  final LinkedHashMap<String, Message> messages;

  MessageWindow({this.messages});
}

class Message {
  String name;
  String message;
  bool complete;

  Message({this.name, this.message, this.complete});
}

class ChatMessage extends Message {
  ChatMessage({name, message, complete}) : super(name: name, message: message, complete: complete);
}

class BuzzMessage extends Message {
  // If the player is currently buzzed, we do not yet know the result of the buzz
  final bool early;
  // We will eventually, though.
  final dynamic correct;
  final bool prompt;

  BuzzMessage({name, message, complete, this.early, this.correct, this.prompt}) : super(name: name, message: message, complete: complete);
}

class LogMessage extends Message {

  LogMessage({name, message, complete}) : super(name: name, message: message, complete: complete);
}

