import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'ShowData.dart';
import 'package:toast/toast.dart';

class App extends StatefulWidget {
  String id;
  App(this.id);
  @override
  _AppState createState() => _AppState();
}
  class _AppState extends State<App> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Data'),
      ),
      body: SingleChildScrollView(
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
               Navigator.push(context, MaterialPageRoute(builder: (context) => ShoData(widget.id)));
             },
             child:Text('Show Data') ,
           ),
         ],
       ),
      ],
    );
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
      ref.child('node-name').child(widget.id).child(key).set(data).then((_) {
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
    return value.length == 0 ? "Enetr Name First" : null;
  }

  String validateMessage(String value)
  {
    return value.length == 0 ? "Enetr Name First" : null;
  }
}

