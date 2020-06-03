import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:provider/provider.dart';
import 'package:wild_tweets/Providers/card_provider.dart';
import 'package:vector_math/vector_math.dart' as math;

class TweetCardPage extends StatefulWidget {
  TweetCardPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TweetCardPageState createState() => _TweetCardPageState();
}

class _TweetCardPageState extends State<TweetCardPage> {
  @override
  void initState() {
    final tweetCard = Provider.of<TweetCardProvider>(context, listen: false);
    tweetCard.getTweets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 40,
              right: 40,
              child: Text(
                "TRUMP",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    fontSize: 90.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 140,
              left: 30,
              right: 30,
              child: Text(
                "TWEETS",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.4),
                    fontSize: 85.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: -60,
              child: Image.asset(
                'assets/images/trump-cartoon-png-4.png',
                height: 400,
                width: 400,
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.35,
                left: 0,
                right: 0,
                child: _buildTweetCards(context)),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.86,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 1,
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: new BoxDecoration(color: Colors.transparent),
                child: Card(
                  elevation: 5.0,
                  shadowColor: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  color: Color.fromRGBO(220, 240, 247, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: Text(
                            "Give 2 drinks if you answer correctly, or take 4 drinks if you answer incorrectly.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTweetCards(BuildContext context) {
    final tweetCard = Provider.of<TweetCardProvider>(context);

    return tweetCard.tweetCardStatus == TweetCardStatus.Loading
        ? Container()
        : Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.95,
            child: TinderSwapCard(
              orientation: AmassOrientation.TOP,
              totalNum: tweetCard.tweetDetails.length,
              stackNum: 6,
              swipeEdge: 4.0,
              maxWidth: MediaQuery.of(context).size.width * 0.95,
              maxHeight: MediaQuery.of(context).size.height * 0.55,
              minWidth: MediaQuery.of(context).size.width * 0.85,
              minHeight: MediaQuery.of(context).size.height * 0.45,
              cardBuilder: (BuildContext context, int index) {
                return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    elevation: 5.0,
                    color: Color.fromRGBO(220, 240, 247, 1),
                    child: Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20.0, right: 20.0),
                              decoration: new BoxDecoration(
                                  color: Colors
                                      .transparent, //new Color.fromRGBO(255, 0, 0, 0.0),
                                  borderRadius: new BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0))),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0))),
                                elevation: 10.0,
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(10.0),
                                  leading: CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: NetworkImage(
                                        'https://pbs.twimg.com/profile_images/874276197357596672/kUuht00m_400x400.jpg'),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        "Donald J. Trump",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "@realDonaldTrump",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Container(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      tweetCard.tweetDetails[index].message,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ButtonTheme(
                                  minWidth: 125.0,
                                  height: 50.0,
                                  child: RaisedButton(
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    padding: EdgeInsets.all(8.0),
                                    textColor: Colors.white,
                                    color: Color.fromRGBO(94, 157, 200, 1),
                                    onPressed: () {
                                      incorrectPopUp(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("VALID!"),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.0)),
                                        Icon(
                                          Icons.thumb_up,
                                          size: 20.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: 125.0,
                                  height: 50.0,
                                  child: RaisedButton(
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    onPressed: () {
                                      correctPopUp(context);
                                    },
                                    textColor: Colors.white,
                                    color: Colors.red,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("BUGGIN!"),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.0)),
                                        Icon(
                                          Icons.thumb_down,
                                          size: 20.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ));
              },
              cardController: tweetCard.cardController = CardController(),
              swipeUpdateCallback:
                  (DragUpdateDetails details, Alignment align) {
                if (align.x < 0) {
                } else if (align.x > 0) {}
              },
              swipeCompleteCallback:
                  (CardSwipeOrientation orientation, int index) {},
            ),
          );
  }

  void correctPopUp(BuildContext context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Center(child: Text('YEET!!')),
                content: Text('You got that shit right af!!'),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 600),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  void incorrectPopUp(BuildContext context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Center(child: Text('OOF!!')),
                content: Text('Negative ghost rider'),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 600),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
