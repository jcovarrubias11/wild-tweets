import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:random_string/random_string.dart';
import 'package:wild_tweets/Models/tweet_card.dart';

enum HomePageStatus { Initial, Loading }

class HomePageProvider with ChangeNotifier {
  HomePageProvider.instance();

  HomePageStatus _homePageStatus = HomePageStatus.Initial;
  String _lobbyCode = "";

  HomePageStatus get homePageStatus => _homePageStatus;
  String get lobbyCode => _lobbyCode;

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

  void loadTweets() async {
    _homePageStatus = HomePageStatus.Loading;
    notifyListeners();

    _lobbyCode = randomAlpha(5).toUpperCase();

    FirebaseDatabase _database = await getDatabase();

    await _database.reference().child(_lobbyCode).set({
      'currentPlayer': '',
      'currentTweet': '',
      'nextTweet': '',
      'partyLeader': '',
      'gameStarted': false,
      'joinable': true,
      'swipes': 0,
    });

    String _tweets =
        await rootBundle.loadString('assets/json/trump_tweets.json');

    List<TweetDetails> _tweetDetails = await parseJson(_tweets);

    List<int> _tweetIndexes =
        List<int>.generate(_tweetDetails.length, (index) => index);

    _tweetIndexes.shuffle();

    await _database
        .reference()
        .child(_lobbyCode)
        .child('tweetIndexes')
        .set(_tweetIndexes);

    _homePageStatus = HomePageStatus.Initial;
    notifyListeners();
  }

  // Util Functions
  Future<List<TweetDetails>> parseJson(String response) async {
    if (response == null) {
      return [];
    }
    final _parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();

    final _listOfTweets = _parsed.asMap().entries.map<TweetDetails>((json) {
      TweetDetails.fromJson(json.value);
    }).toList();

    return _listOfTweets;
  }
}
