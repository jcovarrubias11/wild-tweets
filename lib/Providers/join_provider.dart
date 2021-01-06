import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

enum JoinStatus { Initial, Submitted }

class JoinProvider with ChangeNotifier {
  JoinProvider.instance();

  JoinStatus _joinStatus = JoinStatus.Initial;
  String _lobbyCode;
  FirebaseDatabase _database;

  JoinStatus get joinStatus => _joinStatus;
  String get lobbyCode => _lobbyCode;

  set joinStatus(value) {
    _joinStatus = value;
    notifyListeners();
  }

  set lobbyCode(value) {
    _lobbyCode = value;
    notifyListeners();
  }

  Future<FirebaseDatabase> getDatabase() async {
    final FirebaseApp _app = await FirebaseApp.configure(
        name: "matches",
        options: Platform.isIOS
            ? const FirebaseOptions(
                googleAppID: "null",
                gcmSenderID: "null",
                databaseURL: "https://wildtweets-e54d7-matches.firebaseio.com/")
            : FirebaseOptions(
                googleAppID: "null",
                apiKey: "null",
                databaseURL:
                    "https://wildtweets-e54d7-matches.firebaseio.com/"));

    FirebaseDatabase _database = FirebaseDatabase(app: _app);

    return _database;
  }
}
