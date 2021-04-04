import 'package:uts/Models/User.dart';
import 'package:uts/prosesLogin/loginRequest.dart';

abstract class LoginCallBack {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}
class LoginResponse {
  LoginCallBack _callBack;
  LoginRequest loginRequest = new LoginRequest();
  LoginResponse(this._callBack);
  doLogin(String username, String password) {
    loginRequest
        .getLogin(username, password)
        .then((user) => _callBack.onLoginSuccess(user))
        .catchError((onError) => _callBack.onLoginError(onError.toString()));
  } 
}