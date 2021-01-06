// Flutter imports
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

// External package imports
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:wild_tweets/Models/card_args.dart';
import 'package:wild_tweets/Pages/card_page.dart';

// Page imports
import 'package:wild_tweets/Pages/home_page.dart';
import 'package:wild_tweets/Pages/lobby_page.dart';
import 'package:wild_tweets/Pages/join_page.dart';

// Provider imports
import 'package:wild_tweets/Providers/home_provider.dart';
import 'package:wild_tweets/Providers/card_provider.dart';
import 'package:wild_tweets/Providers/join_provider.dart';
import 'package:wild_tweets/Providers/lobby_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseApp app = await FirebaseApp.configure(
      name: "matches",
      options: Platform.isIOS
          ? const FirebaseOptions(
              googleAppID: "null",
              gcmSenderID: "null",
              databaseURL: "https://wildtweets-e54d7-matches.firebaseio.com/")
          : FirebaseOptions(
              googleAppID: "null",
              apiKey: "null",
              databaseURL: "https://wildtweets-e54d7-matches.firebaseio.com/"));


  runApp(MaterialApp(
      home: MyApp(
    app: app,
  )));
}

class MyApp extends StatelessWidget {
  MyApp({this.app});
  final FirebaseApp app;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TweetCardProvider>(
          create: (BuildContext context) => TweetCardProvider.instance(),
        ),
        ChangeNotifierProvider<HomePageProvider>(
          create: (BuildContext context) => HomePageProvider.instance(),
        ),
        ChangeNotifierProvider<LobbyProvider>(
            create: (BuildContext context) => LobbyProvider.instance()),
        ChangeNotifierProvider<JoinProvider>(
            create: (BuildContext context) => JoinProvider.instance()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {

          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (_) => HomePage(
                        app: app,
                      ));
            case '/lobby':
              final arguments = settings.arguments;
              return MaterialPageRoute(
                  builder: (_) => LobbyPage(
                        database: arguments,
                      ));
            case '/join':
              final arguments = settings.arguments;
              return MaterialPageRoute(
                  builder: (_) => JoinPage(
                        database: arguments,
                      ));
            case '/card':
              final CardArgs args = settings.arguments;
              return MaterialPageRoute(
                  builder: (_) => TweetCardPage(
                        database: args.database,
                        username: args.username,
                        lobbycode: args.lobbycode,
                      ));
            default:
              final arguments = settings.arguments;
              return MaterialPageRoute(
                  builder: (_) => HomePage(
                        app: arguments,
                      ));
          }
        },
      ),
    );
  }
}
