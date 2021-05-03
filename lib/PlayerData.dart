class PlayerData {
  String name;
  int score = 0;
  int prevPos;

  PlayerData(this.name, this.score, this.prevPos);

  PlayerData.fromMap(Map map)
      : this.name = map['name'],
        this.score = map['score'],
        this.prevPos = map['prevPos'];

  Map toMap() {
    return {
      'name': this.name,
      'score': this.score,
      'prevPos': this.prevPos,
    };
  }
}
