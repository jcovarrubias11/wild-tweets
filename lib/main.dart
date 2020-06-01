import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wild_tweets/Providers/card_provider.dart';

import 'Pages/card_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TweetCardProvider>(
          create: (BuildContext context) => TweetCardProvider.instance(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TweetCardPage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
