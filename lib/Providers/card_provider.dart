import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:wild_tweets/Models/tweet_card.dart';

enum TweetCardStatus { Inital, Loading, Loaded }

class TweetCardProvider with ChangeNotifier {
  TweetCardProvider.instance();

  CardController cardController;
  TweetCardStatus _tweetCardStatus = TweetCardStatus.Inital;
  List<TweetDetails> _tweetDetails = List<TweetDetails>();
}
