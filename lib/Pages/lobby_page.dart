import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wild_tweets/Models/card_args.dart';
import 'package:wild_tweets/Providers/card_provider.dart';
import 'package:wild_tweets/Providers/lobby_provider.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key key, this.database}) : super(key: key);

  final FirebaseDatabase database;

  LobbyPageState createState() => LobbyPageState();
}

class LobbyPageState extends State<LobbyPage> {
  static final GlobalKey<FormState> _lobbyFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  List<String> players = List<String>();
  String userName;

  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<TweetCardProvider>(context, listen: false);

    widget.database
        .reference()
        .child(cardProvider.lobbyCode)
        .child('players')
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
      } else {
        for (String name in snapshot.value) {
          players.add(name);
        }
      }
    });

    return Scaffold(
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
            Consumer<LobbyProvider>(builder: (context, lobby, _) {
              return lobby.lobbyStatus == LobbyStatus.Initial
                  ? Container()
                  : lobby.lobbyStatus == LobbyStatus.Loading
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.5),
                          child: FirebaseAnimatedList(
                            query: widget.database
                                .reference()
                                .child(cardProvider.lobbyCode)
                                .child('players'),
                            itemBuilder: (_, DataSnapshot snapshot,
                                Animation<double> animation, int index) {
                              return buildPlayerListTile(
                                  context,
                                  snapshot.value.toString(),
                                  MainAxisAlignment.center);
                            },
                          ),
                        );
            }),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.07,
              left: 40,
              right: 40,
              child: Container(
                child: Text(
                  "Lobby Code:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: 40,
              right: 40,
              child: Container(
                child: Text(
                  "${cardProvider.lobbyCode}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontSize: MediaQuery.of(context).size.width * 0.2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Consumer<LobbyProvider>(builder: (context, lobby, _) {
              return lobby.lobbyStatus == LobbyStatus.Initial
                  ? Positioned(
                      top: MediaQuery.of(context).size.height * 0.27,
                      left: 40,
                      right: 40,
                      child: Container(
                        child: Text(
                          "Player Name:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : lobby.lobbyStatus == LobbyStatus.Loading
                      ? Container()
                      : Container();
            }),
            Consumer<LobbyProvider>(builder: (context, lobby, _) {
              return lobby.lobbyStatus == LobbyStatus.Initial
                  ? Positioned(
                      top: MediaQuery.of(context).size.height * 0.32,
                      left: 40,
                      right: 40,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        child: Form(
                          key: _lobbyFormKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
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
                            ],
                          ),
                        ),
                      ),
                    )
                  : lobby.lobbyStatus == LobbyStatus.Loading
                      ? Container()
                      : Container();
            }),
            Consumer<LobbyProvider>(builder: (context, lobby, _) {
              return lobby.lobbyStatus == LobbyStatus.Initial
                  ? Positioned(
                      top: MediaQuery.of(context).size.height * 0.45,
                      left: MediaQuery.of(context).size.width * 0.20,
                      right: MediaQuery.of(context).size.width * 0.20,
                      child: Container(
                        child: ButtonTheme(
                            minWidth: 125.0,
                            height: 40.0,
                            child: RaisedButton(
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              padding: EdgeInsets.all(8.0),
                              textColor: Colors.white,
                              color: Color.fromRGBO(94, 157, 200, 1),
                              onPressed: () async {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_lobbyFormKey.currentState.validate()) {
                                  // Add username to players list to put into DB
                                  players.remove('');
                                  players.add(_usernameController.text);

                                  // Set user name to keep track of user during turns
                                  cardProvider.username =
                                      _usernameController.text;

                                  lobby.setUpDbFields(cardProvider.lobbyCode,
                                      cardProvider.username, players);
                                }
                              },
                              child: Text('Submit'),
                            )),
                      ))
                  : lobby.lobbyStatus == LobbyStatus.Loading
                      ? Positioned(
                          top: MediaQuery.of(context).size.height * 0.30,
                          left: MediaQuery.of(context).size.width * 0.20,
                          right: MediaQuery.of(context).size.width * 0.20,
                          child: Container(child: CircularProgressIndicator()),
                        )
                      : Positioned(
                          top: MediaQuery.of(context).size.height * 0.30,
                          left: MediaQuery.of(context).size.width * 0.20,
                          right: MediaQuery.of(context).size.width * 0.20,
                          child: Container(
                            child: ButtonTheme(
                                minWidth: 40.0,
                                height: 100.0,
                                child: RaisedButton(
                                  elevation: 10.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  textColor: Colors.white,
                                  color: Color.fromRGBO(94, 157, 200, 1),
                                  onPressed: () {
                                    lobby.startGame(cardProvider.lobbyCode);

                                    print(widget.database);
                                    print(cardProvider.username);
                                    print(cardProvider.lobbyCode);
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.popAndPushNamed(
                                          context, '/card',
                                          arguments: CardArgs(
                                              widget.database,
                                              cardProvider.username,
                                              cardProvider.lobbyCode));
                                    });
                                  },
                                  child: Text('Start Game',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ));
            }),
            Consumer<LobbyProvider>(builder: (context, lobby, _) {
              return lobby.lobbyStatus == LobbyStatus.Initial
                  ? Container()
                  : lobby.lobbyStatus == LobbyStatus.Loading
                      ? Container()
                      : Positioned(
                          top: MediaQuery.of(context).size.height * 0.45,
                          left: MediaQuery.of(context).size.width * 0.30,
                          right: MediaQuery.of(context).size.width * 0.30,
                          child: Container(
                            child: Text("Start game once everyone has joined",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.5),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                    fontWeight: FontWeight.bold)),
                          ));
            }),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget buildPlayerListTile(
      BuildContext context, String name, MainAxisAlignment alignment) {
    return Row(
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
      mainAxisAlignment: alignment,
    );
  }
}
