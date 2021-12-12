//this file has the models for the app

class Sub {
  String? name;
  Sub({this.name});
}

class Request {
  String? student;
  Request({this.student});
}

class DoubtModel {
  String? title;
  String? description;
  bool? solved;
}

class Messages {
  String? from;
  String? message;
  String? time;
  String? type;
  String? title;
  String? description;
  Messages(
      {this.from,
      this.message,
      this.time,
      this.type,
      this.title,
      this.description});
}
