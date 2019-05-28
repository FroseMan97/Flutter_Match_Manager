import 'package:Zenit/auth/model/user_model.dart';

class MatchEmp {
  List<User> _requests;
  List<User> _workers;

  List<User> get getRequests => _requests;
  
  List<User> get getWorkers => _workers;

  MatchEmp(this._requests, this._workers);
}
