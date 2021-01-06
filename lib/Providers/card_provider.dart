import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:wild_tweets/Models/tweet_card.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

enum TweetCardStatus { Inital, Loading, Loaded }

class TweetCardProvider with ChangeNotifier {
  TweetCardProvider.instance();

  CardController cardController;
  List<TweetDetails> _tweetDetails = List<TweetDetails>();
  List<dynamic> _tweetIndexes = List<int>();
  List<dynamic> _players = List<dynamic>();
  FirebaseApp _app;
  FirebaseDatabase _database;
  TweetCardStatus _tweetCardStatus = TweetCardStatus.Inital;
  String _punishment;
  int _swipes = 0;
  int _index = 0;
  String _username;
  String _lobbyCode;

  List<dynamic> get tweetIndexes => _tweetIndexes;
  List<dynamic> get players => _players;
  TweetCardStatus get tweetCardStatus => _tweetCardStatus;
  String get punishment => _punishment;
  int get swipes => _swipes;
  String get username => _username;
  String get lobbyCode => _lobbyCode;
  int get index => _index;

  set swipes(int newSwipes) => {_swipes = newSwipes};
  set username(String newUsername) => {_username = newUsername};
  set lobbyCode(String newLobby) => {_lobbyCode = newLobby};

  Future<void> getTweets() async {
    _tweetCardStatus = TweetCardStatus.Loading;

    notifyListeners();

    String _tweets =
        await rootBundle.loadString('assets/json/trump_tweets.json');

    _tweetDetails = await parseJson(_tweets);

    _app = await FirebaseApp.configure(
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

    _database = FirebaseDatabase(app: _app);

    await _database
        .reference()
        .child(_lobbyCode)
        .child('tweetIndexes')
        .once()
        .then((DataSnapshot snapshot) => _tweetIndexes = snapshot.value);

    await _database
        .reference()
        .child(_lobbyCode)
        .child('currentTweet')
        .set(_tweetDetails[_tweetIndexes[_index]].message);

    await _database
        .reference()
        .child(_lobbyCode)
        .child('nextTweet')
        .set(_tweetDetails[_tweetIndexes[_index + 1]].message);

    await _database
        .reference()
        .child(_lobbyCode)
        .child('players')
        .once()
        .then((DataSnapshot snapshot) async {
      _players = await snapshot.value;
    });

    _tweetCardStatus = TweetCardStatus.Loaded;

    notifyListeners();
  }

  Future<void> setTweets(int index) async {
    _tweetCardStatus = TweetCardStatus.Loading;

    notifyListeners();

    _index = index;

    await _database
        .reference()
        .child(_lobbyCode)
        .child('currentTweet')
        .set(_tweetDetails[_tweetIndexes[_index]].message);

    await _database
        .reference()
        .child(_lobbyCode)
        .child('nextTweet')
        .set(_tweetDetails[_tweetIndexes[_index + 1]].message);

    _tweetCardStatus = TweetCardStatus.Loaded;

    notifyListeners();
  }

  Future<List<TweetDetails>> parseJson(String response) async {
    if (response == null) {
      return [];
    }
    final _parsed =
        await json.decode(response.toString()).cast<Map<String, dynamic>>();

    final _listOfTweets = await _parsed
        .map<TweetDetails>((json) => new TweetDetails.fromJson(json))
        .toList();

    return _listOfTweets;
  }

  void getPunishments() {
    List<String> _genders = ["guy", "girl"];

    var _gender = _genders[next(0, 1)];

    List<String> _directions = ["left", "right"];

    var _direction = _directions[next(0, 1)];

    List<String> _people = [
      "Donald Trump",
      "Kanye West",
      "Joe Exotic",
      "Stephen Hawking",
      "Nicki Minaj",
      "Morgan Freeman",
      "Bad Bunny",
      "French man trying to be american",
    ];

    var _person = _people[next(0, 7)];

    List<String> _punishments = [
      "take a shot with the TALLEST person.",
      "Descirbe your sexual fantasy",
      "CONFESSION: Tell eveyrone one of your darkest secrets",
      "Rock, Paper, Scissors: Choose someone to play and winner drinks!",
      "Sip for every year of college",
      "Take a shot",
      "MYSTERY SHOT: Person to the $_direction gets to choose a shot for you to take",
      "Take a shot with no hands",
      "Make a 30 second toast talking like $_person",
      "6 second chug",
      "Give your best $_person impression and then drink",
      "Give a lap dance to the person to your $_direction",
      "Act out a sexual position for 15 seconds",
      "Lick someones neck",
      "6 second waterfall",
      "Dance for 10 seconds while drinking",
      "JUMP SHOT: Take a shot and jump at the same time",
      "Serenade a $_gender",
      "Nibble on someones ear, if you do not then take 2 shots",
      "Do a tik tok dance"
    ];

    _punishment = _punishments[next(0, 19)];
    notifyListeners();
  }

  int next(int min, int max) {
    var _rnd = Random();
    return (min + _rnd.nextInt(max - min));
  }
}
