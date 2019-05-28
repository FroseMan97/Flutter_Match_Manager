class User {
  String _id;
  String _name;
  String _surname;
  String _phone;
  String _avatar; // URL

  User(this._id, this._name, this._surname, this._phone, this._avatar);

  get getID => _id;
  get getName => _name;
  get getSurname => _surname;
  get getPhone => _phone;
  get getAvatar => _avatar;

  @override
  String toString() =>
      'User [ id: $_id, name: $_name, surname: $_surname, phone: $_phone ]';
}
