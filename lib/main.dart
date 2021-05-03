import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PlayerData.dart';

void main() {
  runApp(MyApp());
}


extension CapExtension on String {
  String get inCaps => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _setScoreCounter = 0;

  List<PlayerData> playersList = [];
  List<String> playersNameList = [];

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  void saveData() {
    List<String> spList = playersList.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('list', spList);
    print("spList");
    print(spList);
  }

  void loadData(){
    List<String> spList = sharedPreferences.getStringList('list');
    playersList = spList.map((item) => PlayerData.fromMap(json.decode(item))).toList();
    setState((){});

  }



  void getName(String name) {

    print(name);
    setState(() {
      _counter++;
      playersList.add(PlayerData(name, 0, _counter));
      playersNameList.add(name);
    });
    print(_counter);
    saveData();
  }

  void setScore(String score, String num) {
    setState(() {
      playersList[int.parse(num)].score = int.parse(score);
    });
    print("score");
    print(score);
  }

  void shufflePlayers() {
    setState(() {
      playersList.shuffle();
      for (int i = 0; i < playersList.length; i++) {
        playersList[i].prevPos = i;
      }
      playersNameList = [];
      for (int i = 0; i < playersList.length; i++) {
        playersNameList.add(playersList[i].name);
      }
    });
    saveData();
  }



  void arrangeTeam() {
    setState(() {
      int i, j, k = 0;

      // playersList.shuffle();
      //finding maxScore
      int maxScore = 0;
      for (i = 0; i < playersList.length; i++) {
        if (playersList[i].score > maxScore) {
          maxScore = playersList[i].score;
        }
      }

      // making sub lists with same scores
      List<PlayerData> tempList = [];
      List<PlayerData> finalList = [];
      var iterScore = maxScore + 1;
      for (i = 0; i < iterScore; i++) {
        tempList = [];
        for (j = 0; j < playersList.length; j++) {
          if (playersList[j].score == maxScore) {
            tempList.add(playersList[j]); //ad .name here to view just names
          }
        }

//    ++ TEMP LIST READY ++ up

//    ++ CHECK IF IT HAS MULTIPLE SAME SCORES ++

        if (tempList.length > 1) {
          tempList.sort((a, b) => a.prevPos.compareTo(b.prevPos));
        }

        maxScore = maxScore - 1;

        if (tempList.length > 0) {
          finalList.addAll(tempList);
        }
      }

      // Setting prevPos to curr pos
      for (i = 0; i < finalList.length; i++) {
        print(finalList[i].prevPos = i);
      }
      playersNameList = [];
      for (i = 0; i < finalList.length; i++) {
        playersNameList.add(finalList[i].name);
      }
      _setScoreCounter = 0;
      playersList = [];
      playersList.addAll(finalList);
    });

    for (int i = 0; i < playersNameList.length; i++) {
      print(playersList[i].score);
    }
    print(playersNameList);
  }

  Future<String> addScore(BuildContext context) {
    TextEditingController customControllerScore = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Player Score"),
            content: TextField(
              controller: customControllerScore,
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                onPressed: () {
                  Navigator.of(context)
                      .pop(customControllerScore.text.toString());
                },
                child: Text("Add"),
              )
            ],
          );
        });
  }

  Future<String> addPlayer(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Player Name"),
            content: TextField(
              controller: customController,
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                onPressed: () {
                  Navigator.of(context).pop(customController.text.toString());
                },
                child: Text("Add"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      appBar: AppBar(
        title: Text("Make a Group"),
      ),
      body: ListView.builder(
        itemCount: playersList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              addScore(context).then((onValue) {
                setScore(onValue, index.toString());
              });
            },
            child: Card(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            playersList[index].name,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 20,
                            child: Text(
                              playersList[index].score.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            tooltip: 'Remove',
                            onPressed: () {
                              setState(() {
                                playersList.removeAt(index);
                              });
                              saveData();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            height: 100.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                        onPressed: arrangeTeam,
                        tooltip: 'Get Ranking',
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.group),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                        onPressed: () {
                          addPlayer(context).then((onValue) {
                            if (onValue != null) {
                              for (int i = 0; i < playersList.length; i++) {
                                if (playersList[i].name == onValue.inCaps){
                                  Fluttertoast.showToast(
                                      msg: onValue+" Already Exists",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  return;
                                }
                              }
                              getName(onValue.inCaps);
                            }
                          });
                        },
                        tooltip: 'Add Player',
                        backgroundColor: Colors.green,
                        child: Icon(Icons.add),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                        onPressed: shufflePlayers,
                        tooltip: 'Shuffle',
                        child: Icon(Icons.shuffle),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            playersList=[];
                          });
                          saveData();
                        },
                        tooltip: 'Remove All',
                        backgroundColor: Colors.red,
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ),
                ])),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
