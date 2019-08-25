import 'dart:collection';

class Chatbox {
  final LinkedHashMap<String, Message> messages;

  Chatbox({this.messages});
}

class Message {
  final String name;
  final String message;
  final bool complete;

  Message({this.name, this.message, this.complete});
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

