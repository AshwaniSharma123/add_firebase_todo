import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'validate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = true;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

   bool isLoggedIn = false;

  @override

  void initState() {
    super.initState();
    getValuesSF();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fire Auth',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
              appBar: AppBar(
                title: Text('Fire Authentication'),
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40,),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            //   hintText: 'User Name',
                            labelText: "user",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          obscureText: _passwordVisible,
                          controller: _passwordController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
//                        border: OutlineInputBorder(borderRadius: BorderRadius
//                            .circular(20.0),
//                        ),
                            //  hintText: 'Password',
                            labelText: "password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible ? Icons.visibility : Icons
                                    .visibility_off, color: Theme
                                  .of(context)
                                  .primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = ! _passwordVisible;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                              elevation: 5.0,
                              child: Text('Sign in',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                              splashColor: Colors.pinkAccent,
                              onPressed: () async {
                                try {
                                  final FirebaseUser user = (await _auth
                                      .signInWithEmailAndPassword(
                                    email: _emailController.text.toString(),
                                    password: _passwordController.text
                                        .toString(),
                                  )).user;
                                  var user1 = _auth.currentUser();
                                  user1.then((data) {
                                    // print("$data");
                                    if (data.uid != null) {
                                      addStringToSF(data.uid);              //for shared preference
                                      print(" Email details ----------------->>>>>>>>>> $data");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
                                    }
                                    else {
                                      print(
                                          'invalid user ----------------->>>>>>>>  $e');
                                    }
                                  });
                                  // debugPrint("login successfully firebase  ");
                                }
                                catch (e) {
                                  debugPrint(
                                      "login failed firebase ---------------->>>>>>>  $e");
                                }
                              }
                          ),
                          SizedBox(height: 40),
                          RaisedButton(
                              elevation: 5.0,
                              child: Text('Register',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),),
                              splashColor: Colors.green,
                              onPressed: () {
                                registerUser();
                              }
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  registerUser() async {
//      debugPrint("email  ${_emailController.text}");
//      debugPrint("password  ${_passwordController.text}");
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.toString(),
      password: _passwordController.text.toString(),
    )).user;
  }

  addStringToSF(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('User Name', _emailController.text);
    prefs.setString('Password',_passwordController.text );
    prefs.setString("userId", user);
    prefs.setBool('isLoggedIn', true);
  }

  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _emailController.text  = prefs.getString('User Name');
    _passwordController.text  = prefs.getString('Password');
    if(prefs.getBool('isLoggedIn') != null){
      print('logged in ---------------------->>>>>>>>>>>>>>>>>>>>>>${prefs.getBool('isLoggedIn')}');

      if(prefs.getBool('isLoggedIn')){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  App()),
        );
      }
    }
  }

}
