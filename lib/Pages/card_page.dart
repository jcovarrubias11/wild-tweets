import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:provider/provider.dart';
import 'package:wild_tweets/Providers/card_provider.dart';

class TweetCardPage extends StatefulWidget {
  TweetCardPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TweetCardPageState createState() => _TweetCardPageState();
}

class _TweetCardPageState extends State<TweetCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[900],
        child: Stack(
          children: <Widget>[
            _buildTweetCards(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTweetCards(BuildContext context) {
    final tweetCard = Provider.of<TweetCardProvider>(context, listen: false);

    return TinderSwapCard(
      orientation: AmassOrientation.TOP,
      totalNum: 12,
      stackNum: 3,
      swipeEdge: 4.0,
      maxWidth: MediaQuery.of(context).size.width * 0.95,
      maxHeight: MediaQuery.of(context).size.height * 0.75,
      minWidth: MediaQuery.of(context).size.width * 0.85,
      minHeight: MediaQuery.of(context).size.height * 0.65,
      cardBuilder: (context, index) => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 5.0,
          color: Colors.grey[300],
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Image.asset('assets/images/didTrump.png'),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
                  Container(
                    child: Image.asset('assets/images/tweetThis.png'),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut lab ore et dolore magna aliqua.Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.0),
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
                              borderRadius: BorderRadius.circular(15.0)),
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () {},
                          child: Text("YEET!"),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 125.0,
                        height: 50.0,
                        child: RaisedButton(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          onPressed: () {},
                          textColor: Colors.white,
                          color: Colors.red,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "NAH!",
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          )),
      cardController: tweetCard.cardController = CardController(),
      swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
        if (align.x < 0) {
        } else if (align.x > 0) {}
      },
      swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {},
    );
  }
}
