import 'package:flutter/material.dart';

import './PlayerCard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class PlayerData {
  var name;
  int score = 0;
  var prevPos;

  PlayerData(this.name, this.score, this.prevPos);
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _setScoreCounter = 0;
  List<dynamic> playersList =[];
  List<String> playersNameList =[];

  void getName(String name){
    print(name);
    setState(() {
      _counter++;
      playersList.add(PlayerData(name, 0, _counter));
      playersNameList.add(name);
    });

    print(_counter);
  }

  void setScore(String score) {
    setState(() {
      playersList[_setScoreCounter].score = int.parse(score);
      _setScoreCounter++;
    });
    print("score");
    print(score);
    print(playersList[_setScoreCounter-1].name);
  }

  void shufflePlayers(){
    setState(() {
      playersList.shuffle();
      playersNameList=[];
      for (int i = 0; i < playersList.length; i++){
        playersNameList.add(playersList[i].name);
      }
    });
  }

  void arrangeTeam(){
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
      var tempList = [];
      var finalList = [];
      var iterScore = maxScore+1;
      for (i = 0; i < iterScore; i++) {
        tempList=[];
        for (j = 0; j < playersList.length; j++) {
          if (playersList[j].score == maxScore) {
            tempList.add(playersList[j]);//ad .name here to view just names
          }
        }

//    ++ TEMP LIST READY ++ up


//    ++ CHECK IF IT HAS MULTIPLE SAME SCORES ++

        if(tempList.length > 1){
          tempList.sort((a, b) => a.prevPos.compareTo(b.prevPos));
        }

        maxScore=maxScore-1;

        if(tempList.length > 0){
          finalList.addAll(tempList);
        }
      }

      // Setting prevPos to curr pos
      for (i = 0; i < finalList.length; i++){
        print(finalList[i].prevPos = i);
      }
      playersNameList=[];
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

  Future<String> addScore(BuildContext context){

    TextEditingController customControllerScore = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Add Player Score"),
        content: TextField(
          controller: customControllerScore,
        ),
        actions: [
          MaterialButton(
            elevation: 5.0,
            onPressed: (){
              Navigator.of(context).pop(customControllerScore.text.toString());
            },
            child:Text("Add"),
          )
        ],
      );
    });
  }


  Future<String> addPlayer(BuildContext context){

    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Add Player Name"),
        content: TextField(
          controller: customController,
        ),
        actions: [
          MaterialButton(
            elevation: 5.0,
            onPressed: (){
              Navigator.of(context).pop(customController.text.toString());
            },
            child:Text("Add"),
          )
        ],
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Make a Group"),

      ),
      body: Column(
        children: [
          ...(playersNameList).map((players){
            return Player(players, _counter);
          }).toList()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          addPlayer(context).then((onValue){
            getName(onValue);
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar:BottomAppBar(
        child: Container(
            height: 50.0,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_box),
                  onPressed: () {
                    addScore(context).then((onValue) {
                      setScore(onValue);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_box),
                  onPressed: arrangeTeam,
                ),
                IconButton(
                  icon: Icon(Icons.access_alarms),
                  onPressed: shufflePlayers,
                ),
              ],
            )
        ),
      ) ,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
