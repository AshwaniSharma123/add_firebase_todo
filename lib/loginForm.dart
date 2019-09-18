//import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/material.dart';
//import 'ShowData.dart';
//import 'package:toast/toast.dart';
//
//void main() => runApp(MaterialApp
//  (debugShowCheckedModeBanner: false,
//  theme: ThemeData(
//    primarySwatch: Colors.indigo,
//  ),
//  home: MyApp(),));
//
//class MyApp extends StatefulWidget {
//
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//
//  GlobalKey<FormState> _key = GlobalKey();
//
//  bool _autoValidate = false;
//  String name,profession,message;
//
//  List<DropdownMenuItem<String>>items = [
//    DropdownMenuItem(
//      child: Text('Student'),
//      value: 'Student',
//    ),
//    DropdownMenuItem(child:
//    Text('professor'),
//      value: 'professor',
//    ),
//  ];
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Firebase list'),
//      ),
//      body: SingleChildScrollView(
//        child: Container(
//          padding: EdgeInsets.all(15.0),
//          child: Form(
//            key: _key,
//            autovalidate: _autoValidate,
//            child:  FormUI(),
//          ),
//        ),
//      ),
//    );
//  }
//  Widget FormUI() {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        TextFormField(
//          decoration: InputDecoration(
//            hintText: "Name",
//          ),
//          onSaved: (val){
//            name = val;
//          },
//          maxLength: 32,
//        ),
//        DropdownButton(items: items,
//            value: profession,
//            hint: Text('Profession'),
//            onChanged: (val){
//              profession =val;
//            }),
//
//        TextFormField(
//          decoration: InputDecoration(
//            hintText: "Message",
//          ),
//          onSaved: (val){
//            message = val;
//          },
//          validator: validateMessage,
//          maxLines: 5,
//          maxLength: 256,
//        ),
//        SizedBox(height: 20,),
//        RaisedButton(
//          splashColor: Colors.indigoAccent,
//          onPressed: _sentToServer,
//          child:Text('Send') ,
//        ),
//        RaisedButton(
//          splashColor: Colors.indigoAccent,
//
//          onPressed: (){
//            Toast.show("Data List", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
//            Navigator.push(context, MaterialPageRoute(builder: (context) => ShoData()));
//          },
//          child:Text('Show Data') ,
//        ),
//      ],
//    );
//  }
//
//  _sentToServer(){
//    if(_key.currentState.validate())
//    {
//      _key.currentState.save();
//      DatabaseReference ref = FirebaseDatabase.instance.reference();
//      var data = {
//        'name' : name,
//        'profession' : profession,
//        'message' : message,
//      };
//      ref.child('node-name').push().set(data).then((_) {
//        _key.currentState.reset();
//      });
//    }else{
//      setState(() {
//        _autoValidate =true;
//      });
//    }
//  }
//
//  //sent to sever method end
//
//  String validateName(String val)
//  {
//    return val.length == 0 ? "Enetr Name First" : null;
//  }
//
////validate name method end
//
//  String validateMessage(String val)
//  {
//    return val.length == 0 ? "Enetr Name First" : null;
//  }
//
////validate message method end
//
//}
