import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final String playerName;
  final int playerPos;

  Player(this.playerName, this.playerPos);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color:Colors.green,
      ),
      height: 70,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              color:Colors.yellowAccent,
            ),
            width:30,
            height:30,
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child:Text(playerPos.toString()),
          ),
          Container(
            height:30,
            color:Colors.pink,
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child:Text(playerName),
          ),

        ],
      ),
    );
  }
}
