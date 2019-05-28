class MatchInfo {
  String _id;
  String _name;
  String _date;
  String _time;
  String _img;
  String _leftDate;
  String _leftTime;
  String _status;

  MatchInfo(
    String id,
    String name,
    String date,
    String time,
    String img,
    String leftDate,
    String leftTime,
    String status
  ) {
    _id = id;
    _name = name;
    _date = date;
    _time = time;
    _img = img;
    _leftDate=leftDate;
    _leftTime=leftTime;
    _status = status;
  }

  String get getID => _id;
  String get getName => _name;
  String get getDate => _date;
  String get getTime => _time;
  String get getImg => _img;
  String get getLeftDate => _leftDate;
  String get getLeftTime => _leftTime;
  String get getStatus => _status;
}
