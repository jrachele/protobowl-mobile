class Chatbox {
  final List<Message> messages;

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
  final bool buzzed;
  // We will eventually, though.
  final bool correct;

  BuzzMessage({this.buzzed, this.correct}) : super();
}

