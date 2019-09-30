import 'package:add_firebase_todo/login.dart';
import 'package:add_firebase_todo/shimmer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ShowData.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}
  class _AppState extends State<App> {
  // DateTime currentBackPressTime = DateTime.now();
  String id;
  bool isProgressVisible = false;
  GlobalKey<FormState> _key = GlobalKey();
  bool _autoValidate = false;
  String name,profession = 'Profession' ,message,key;
  List<DropdownMenuItem<String>>items = [
    DropdownMenuItem(
      child: Text('Student'),
      value: 'Student',
    ),
    DropdownMenuItem(
      child: Text('professor'),
      value: 'professor',
    ),
  ];
//
//    DateTime now = DateTime.now();
//  Future<bool> onWillPop()  {
//
//    if (now.difference(currentBackPressTime) > Duration(seconds: 5)) {
//     // SystemNavigator.pop();
//      currentBackPressTime = now;
//      //showMessage("Double Press Back Button to exit.");
//      Toast.show('do you want to exit', context,duration: Toast.LENGTH_LONG);
//      return Future.value(false);
//    }
//    return Future.value(true);
//  }


  Future<bool> onWillPop()  {
//    counter = counter + 1;
//    if(counter == 1){
//      Toast.show("press again to exit", context);
//    }
//    else{
//      SystemNavigator.pop();
//    }

    return showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        title:  Text('Are you sure?'),
        content:  Text('Do you want to exit an App'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => SystemNavigator.pop(),
            child:  Text('Yes'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child:  Text('NO'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  void initState() {
    super.initState();

    getValuesSF();
    setState(() {
      isProgressVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: onWillPop,
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Submit Data'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call_missed_outgoing),
            onPressed: (){
              _showDialog();
            },
          )
        ],
      ),
      body: isProgressVisible ? ShimmerClass(): SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height*0.89,
          padding: EdgeInsets.all(25.0),
          child: Form(
            key: _key,
            autovalidate: _autoValidate,
            child:  formUI(),
          ),
        ),
      ),
    ),
    );
  }
  Widget formUI() {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            hintText: "Enter Name",
          ),
          onSaved: (val){
            name = val;
          },
          maxLength: 32,
        ),
        DropdownButton(
            items: items,
            //value: profession,
            hint: Text('$profession'),
           onChanged: (val){
              setState(() {
                profession = val;
              });
           }
            ),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Message",
          ),
          onSaved: (val){
              message = val;
          },
          validator: validateMessage,
          maxLines: 5,
          maxLength: 256,
        ),
        SizedBox(height: 20,),
        Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
           RaisedButton(
             elevation: 10.0,
             splashColor: Colors.red,
             onPressed: _sentToServer,
             child:Text('Send') ,
           ),
           RaisedButton(
             elevation: 20.0,
             splashColor: Colors.green,
             onPressed: (){
               Toast.show("Data List", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
               Navigator.push(context, MaterialPageRoute(builder: (context) => ShoData(id)));
             },
             child:Text('Show Data'),
           ),
         ],
       ),
      ],
    );
  }


  _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:  Text("Are you sure to logout"),
          //content:  Text("How Are You"),
          actions: <Widget>[
            FlatButton(
              child:  Text("Log Out"),
              onPressed: () {
                removeValues();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Login()),
                );
              },
            ),
            // usually buttons at the bottom of the dialog
            FlatButton(
              child:  Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

    getValuesSF() async {
      setState(() {
        isProgressVisible = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString('userId') != null){
        id = prefs.getString('userId');
      }
    }

  _sentToServer(){
    if(_key.currentState.validate())
    {
      _key.currentState.save();
      DatabaseReference ref = FirebaseDatabase.instance.reference();
      key = ref.push().key;
      var data = {
        'name' : name,
        'id' :  key,
        'profession' : profession,
        'message' : message,
      };
      ref.child('node-name').child(id).child(key).set(data).then((_) {
        _key.currentState.reset();
      });
    }else{
      setState(() {
        _autoValidate =true;
      });
    }
  }

  String validateName(String value)
  {
    return value.length == 0 ? "Enter Name First" : null;
  }

  String validateMessage(String value)
  {
    return value.length == 0 ? "Enter Message" : null;
  }
  }

  uid(){

  }

removeValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();              //for remove
  prefs.clear();
  print('logout-------------------------->>>>>>>>>>>>>>>>>>>>>>>>>');            //shared preference
}




