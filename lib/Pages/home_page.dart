// Flutter imports
import 'package:flutter/material.dart';

// External package imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

// Provider imports
import 'package:wild_tweets/Providers/home_provider.dart';
import 'package:wild_tweets/Providers/card_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    this.app,
  }) : super(key: key);
  final FirebaseApp app;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase database = FirebaseDatabase();

  @override
  void initState() {
    super.initState();

    database = FirebaseDatabase(app: widget.app);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: buildInitialHomeButtons(context));
  }

  Container buildInitialHomeButtons(BuildContext context) {
    final cardProvider = Provider.of<TweetCardProvider>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          // Trump Heading Letters
          Positioned(
            top: MediaQuery.of(context).size.height * 0.07,
            left: 40,
            right: 40,
            child: Text(
              "TRUMP",
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  fontSize: MediaQuery.of(context).size.height * 0.119,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // Tweet heading Letters
          Positioned(
            top: MediaQuery.of(context).size.height * 0.20,
            left: 30,
            right: 30,
            child: Text(
              "TWEETS",
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.4),
                  fontSize: MediaQuery.of(context).size.height * 0.112,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // Background trump image
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            child: Image.asset(
              'assets/images/trump_bigLaughStill.png',
              height: 400,
              width: 400,
            ),
          ),
          // Multi Player Button
          Consumer<HomePageProvider>(builder: (context, homePageProvider, _) {
            return homePageProvider.homePageStatus == HomePageStatus.Initial
                ? Positioned(
                    top: MediaQuery.of(context).size.height * 0.65,
                    left: 40,
                    right: 40,
                    child: ButtonTheme(
                      minWidth: 125.0,
                      height: 60.0,
                      child: RaisedButton(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        padding: EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        color: Color.fromRGBO(94, 157, 200, 1),
                        onPressed: () async {
                          homePageProvider.loadTweets();
                          cardProvider.lobbyCode = homePageProvider.lobbyCode;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushNamed(context, '/lobby',
                                arguments: database);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("NEW GAME"),
                          ],
                        ),
                      ),
                    ),
                  )
                : SpinKitFoldingCube(
                    color: Color.fromRGBO(94, 157, 200, 1),
                    size: 50.0,
                  );
          }),
          // Join Lobby Button
          Consumer<HomePageProvider>(builder: (context, homePageProvider, _) {
            return homePageProvider.homePageStatus == HomePageStatus.Initial
                ? Positioned(
                    top: MediaQuery.of(context).size.height * 0.8,
                    left: 40,
                    right: 40,
                    child: ButtonTheme(
                      minWidth: 125.0,
                      height: 60.0,
                      child: RaisedButton(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        padding: EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        color: Color.fromRGBO(94, 157, 200, 1),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushNamed(context, '/join',
                                arguments: database);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("JOIN GAME"),
                          ],
                        ),
                      ),
                    ),
                  )
                : SpinKitFoldingCube(
                    color: Color.fromRGBO(94, 157, 200, 1),
                    size: 50.0,
                  );
          }),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment(1, 1.5),
          stops: [0.0, 0.5, 0.5, 1],
          colors: [
            Color(0xff0C2C52), //red
            Color(0xff0C2C52), //red
            Color(0xffffffff), //white
            Color(0xffffffff), //white
          ],
          tileMode: TileMode.repeated,
        ),
      ),
    );
  }
}
