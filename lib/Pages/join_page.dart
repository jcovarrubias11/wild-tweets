import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wild_tweets/Models/card_args.dart';
import 'package:wild_tweets/Providers/card_provider.dart';
import 'package:wild_tweets/Providers/join_provider.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key key, this.database}) : super(key: key);

  final FirebaseDatabase database;

  JoinPageState createState() => JoinPageState();
}

class JoinPageState extends State<JoinPage> {
  static final GlobalKey<FormState> _joinFormKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> _joinScaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _lobbyController = TextEditingController();
  List<String> players = List<String>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<TweetCardProvider>(context, listen: false);

    return Scaffold(
      key: _joinScaffoldKey,
      resizeToAvoidBottomInset: false,
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
              top: MediaQuery.of(context).size.height * 0.02,
              child: Image.asset(
                'assets/images/vote_trump.png',
                height: 400,
                width: 400,
              ),
            ),
            Consumer<JoinProvider>(builder: (context, joinProvider, _) {
              return joinProvider.joinStatus == JoinStatus.Initial
                  ? Container()
                  : Container(
                      child: StreamBuilder(
                          stream: widget.database
                              .reference()
                              .child(cardProvider.lobbyCode)
                              .child('gameStarted')
                              .onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.data == null) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      elevation: 5.0,
                                      color: Color.fromRGBO(220, 240, 247, 1),
                                      child: Container(
                                        color: Colors.transparent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.75,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: 20.0, right: 20.0),
                                                  decoration: new BoxDecoration(
                                                      color: Colors
                                                          .transparent, //new Color.fromRGBO(255, 0, 0, 0.0),
                                                      borderRadius:
                                                          new BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      20.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      20.0))),
                                                  child:
                                                      CircularProgressIndicator()),
                                            ]),
                                      )));
                            } else {
                              if (snapshot.data.snapshot.value == true) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.popAndPushNamed(context, '/card',
                                      arguments: CardArgs(
                                          widget.database,
                                          cardProvider.username,
                                          cardProvider.lobbyCode));
                                });
                              }
                              return Container();
                            }
                          }),
                    );
            }),
            Consumer<JoinProvider>(builder: (context, joinProvider, _) {
              return joinProvider.joinStatus == JoinStatus.Initial
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.5),
                      child: FirebaseAnimatedList(
                        query: widget.database
                            .reference()
                            .child(_lobbyController.text)
                            .child('players'),
                        itemBuilder: (_, DataSnapshot snapshot,
                            Animation<double> animation, int index) {
                          return _buildPlayerListTile(
                              context,
                              snapshot.value.toString(),
                              MainAxisAlignment.center);
                        },
                      ),
                    );
            }),
            Consumer<JoinProvider>(builder: (context, joinProvider, _) {
              return joinProvider.joinStatus == JoinStatus.Initial
                  ? Positioned(
                      top: MediaQuery.of(context).size.height * 0.07,
                      left: 40,
                      right: 40,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        child: Form(
                          key: _joinFormKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Enter Lobby Code:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 50.0),
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                child: TextFormField(
                                  controller: _lobbyController,
                                  maxLength: 5,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "Ex: XRLYF",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Lobby Code';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Player Name:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                child: TextFormField(
                                  controller: _usernameController,
                                  maxLength: 15,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "Ex: Carol Baskins",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: ButtonTheme(
                                    minWidth:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 40.0,
                                    child: RaisedButton(
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      padding: EdgeInsets.all(8.0),
                                      textColor: Colors.white,
                                      color: Color.fromRGBO(94, 157, 200, 1),
                                      onPressed: () async {
                                        // Validate returns true if the form is valid, otherwise false.
                                        if (_joinFormKey.currentState
                                            .validate()) {
                                          // Add username to players list to put into DB

                                          // Set user name to keep track of user during turns
                                          cardProvider.username =
                                              _usernameController.text;
                                          cardProvider.lobbyCode =
                                              _lobbyController.text;

                                          await widget.database
                                              .reference()
                                              .child(cardProvider.lobbyCode)
                                              .child('joinable')
                                              .once()
                                              .then((DataSnapshot
                                                  snapshot) async {
                                            if (snapshot.value == null) {
                                              joinProvider.joinStatus =
                                                  JoinStatus.Initial;
                                              //show dialog about no lobby with that name
                                            } else if (snapshot.value == true) {
                                              await widget.database
                                                  .reference()
                                                  .child(cardProvider.lobbyCode)
                                                  .child('players')
                                                  .once()
                                                  .then((DataSnapshot
                                                      snapshot) async {
                                                if (snapshot.value == null) {
                                                  joinProvider.joinStatus =
                                                      JoinStatus.Initial;
                                                  //show dialog about no lobby with that name
                                                } else {
                                                  for (String name
                                                      in snapshot.value) {
                                                    players.add(name);
                                                  }
                                                  players.add(
                                                      cardProvider.username);
                                                  players.remove('');

                                                  // Update player names
                                                  await widget.database
                                                      .reference()
                                                      .child(cardProvider
                                                          .lobbyCode)
                                                      .child('players')
                                                      .set(players);

                                                  // Change lobby status for updated widgets
                                                  joinProvider.joinStatus =
                                                      JoinStatus.Submitted;
                                                }
                                              });
                                            } else if (snapshot.value ==
                                                false) {
                                              _usernameController.clear();
                                              _lobbyController.clear();
                                            } else {
                                              _usernameController.clear();
                                              _lobbyController.clear();
                                              joinProvider.joinStatus =
                                                  JoinStatus.Initial;
                                              //show dialog about no lobby with that name
                                            }
                                          });
                                        }
                                      },
                                      child: Text('Submit'),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerListTile(
      BuildContext context, String name, MainAxisAlignment alignment) {
    return Row(
      mainAxisAlignment: alignment,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          margin: EdgeInsets.only(top: 6.0),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              color: Color.fromRGBO(94, 157, 200, 1),
              borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                name.toUpperCase(),
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
