import 'package:firebase_database/firebase_database.dart';

class CardArgs {
  final FirebaseDatabase database;
  final String username;
  final String lobbycode;

  CardArgs(this.database, this.username, this.lobbycode);
}
