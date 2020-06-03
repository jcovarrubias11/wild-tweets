import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:wild_tweets/Models/tweet_card.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

enum TweetCardStatus { Inital, Loading, Loaded }

class TweetCardProvider with ChangeNotifier {
  TweetCardProvider.instance();

  CardController cardController;
  TweetCardStatus _tweetCardStatus = TweetCardStatus.Inital;
  List<TweetDetails> _tweetDetails = List<TweetDetails>();

  TweetCardStatus get tweetCardStatus => _tweetCardStatus;
  List<TweetDetails> get tweetDetails => _tweetDetails;

  Future<void> getTweets() async {
    _tweetCardStatus = TweetCardStatus.Loading;

    String _tweets = await rootBundle.loadString('assets/json/trump_tweets.json');

    _tweetDetails = parseJson(_tweets);
    
    _tweetCardStatus = TweetCardStatus.Loaded;

    notifyListeners();
  }

  List<TweetDetails> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed
        .map<TweetDetails>((json) => new TweetDetails.fromJson(json))
        .toList();
  }

  String getPunishments(){
    var _punishments = ["take a shot with the TALLEST person.", 
    "descirbe your sexual fantasy", 
    "CONFESSION: Tell eveyrone one of your darkest secrets", 
    "Rock, Paper, Scissors: loser drinks!",
    "Sip for every year of college",
    "Take a shot",
    "MYSTERY SHOT: Person to the left gets to choose a shot for you to take",
    "Take a shot with no hands",
    "Make a 30 second toast talking like Joe Exotic",
    "6 second chug",
    "Give your best Donald Trump impression and then drink",
    "Give a lap dance to the person to your right",
    "Act out a sexual position for 15 seconds",
    "Lick someones neck",
    "6 second waterfall",
    "Dance for 20 seconds",
    ];
  }
}
