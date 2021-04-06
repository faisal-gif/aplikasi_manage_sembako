class User {
  int _id;
  String _username;
  String _password;
  String _name;

  int get id => _id;
  String get username => this._username;
  set username(String value) => this._username = value;
  String get password => this._password;
  set password(String value) => this._password = value;
  String get name => this._name;
  set name(String value) => this._name = value;

// konstruktor versi 1
  User(this._username, this._password, this._name);
// konstruktor versi 2: konversi dari Map ke Item
  User.fromMapUser(Map<String, dynamic> map) {
    this._id = map['id'];
    this._username = map['username'];
    this._password = map['password'];
    this._name = map['name'];
  }
  // konversi dari Item ke Map
  Map<String, dynamic> toMapUser() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['username'] = username;
    map['password'] = password;
    map['name'] = name;
    return map;
  }
}
