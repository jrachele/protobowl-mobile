import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseModel {
  final int id;
  final String room;
  final String cookie;
  DatabaseModel({this.id, this.room, this.cookie});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "room": room,
      "cookie": cookie,
    };
  }
}

