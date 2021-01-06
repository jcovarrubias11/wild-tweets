import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

enum LobbyStatus { Initial, Loading, Submitted }

class LobbyProvider with ChangeNotifier {
  LobbyProvider.instance();

  LobbyStatus _lobbyStatus = LobbyStatus.Initial;
  String _userName;
  FirebaseDatabase _database;

  LobbyStatus get lobbyStatus => _lobbyStatus;
  String get userName => _userName;

  set lobbyStatus(value) {
    _lobbyStatus = value;
    notifyListeners();
  }

  set userName(value) => _userName = value;

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

  Future<void> setUpDbFields(
      String lobbyCode, String username, List<String> players) async {
    _lobbyStatus = LobbyStatus.Loading;
    notifyListeners();

    _database = await getDatabase();

    await _database.reference().child(lobbyCode).child('players').set(players);

    await _database
        .reference()
        .child(lobbyCode)
        .child('partyLeader')
        .set(username);

    await _database
        .reference()
        .child(lobbyCode)
        .child('currentPlayer')
        .set(username);

    _lobbyStatus = LobbyStatus.Submitted;
    notifyListeners();
  }

  Future<void> startGame(String lobbyCode) async {
    _lobbyStatus = LobbyStatus.Loading;
    notifyListeners();

    await _database.reference().child(lobbyCode).child('joinable').set(false);

    await _database.reference().child(lobbyCode).child('gameStarted').set(true);

    _lobbyStatus = LobbyStatus.Initial;
    notifyListeners();
  }
}
