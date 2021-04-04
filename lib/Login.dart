import 'package:flutter/material.dart';
import 'package:uts/Home.dart';
import 'DbHelper/DbHelper.dart';
import 'package:uts/Models/User.dart';
import 'package:uts/prosesLogin/loginResponse.dart';
import 'Models/User.dart';
import 'package:uts/Register.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginCallBack {
  BuildContext _ctx;
  DbHelper dbHelper = DbHelper();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  LoginResponse _response;

  _LoginPageState() {
    _response = new LoginResponse(this);
  }
  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _response.doLogin(userNameController.text, passwordController.text);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/Logo.png'),
        // child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      
      controller: userNameController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    _ctx = context;
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: _submit,
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Register',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () async {
        var user = await navigateToRegister(context, null);
        if (user != null) {
          int result = await dbHelper.insertUser(user);
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 150),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }

  @override
  void onLoginError(String error) {
    // TODO: implement onLoginError
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(User user) async {
    // TODO: implement onLoginSuccess
    if (user != null) {
      Navigator.pushNamed(context,Home.tag,arguments:user);
    } else {
      // TODO: implement onLoginSuccess
      _showSnackBar("Login Gagal, Silahkan Periksa Login Anda");
      setState(() {
        _isLoading = false;
      });
    }
  }
}

Future<User> navigateToRegister(BuildContext context, User user) async {
  var result = await Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) {
    return RegisterPage(user);
  }));
  return result;
}
