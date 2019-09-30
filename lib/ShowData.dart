import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MyData.dart';
import 'shimmer.dart';

class ShoData extends StatefulWidget {
  String getId;

  ShoData(this.getId);
  @override
  _ShoDataState createState() => _ShoDataState();
}

class _ShoDataState extends State<ShoData> {
  String name ,message,profession,key;
  List<myData> allData = [];
  var _updateController = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instance.reference();                                //fireBase reference

  @override
  void initState() {
    allData.clear();
    //DatabaseReference ref = FirebaseDatabase.instance.reference();                           //for global access we declare above in class
    ref.child('node-name').child(widget.getId).once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      for(var key in keys){
       myData d =  myData(
            data[key]['name'],
            data[key]['message'],
            data[key]['profession'],
            data[key]['id']
       );
        allData.add(d);
      }
      setState(() {
        print('length: ${allData.length}');
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  Text('Firebase List'),
//        actions: <Widget>[
//          InkWell(
//            child:Icon(Icons.refresh),
//            onTap: (){
//             initState();
//            },
//          ),
//        ],
      ),
      body:  Container(
          child: allData.length == 0 ? ShimmerClass()
          /*Center(child:Text('No Data is Available',style: TextStyle(
            fontSize: 20.0,),),)*/ : ListView.builder(
            itemCount: allData.length,
            itemBuilder: (_, index) {
              return UI(
                allData[index].name,
                allData[index].profession,
                allData[index].message,
                allData[index].id
              );
            },
          ),
        ),
      );
  }

  Widget UI(String name,String profession,String message,String id){
    return Card(
      elevation: 10.0,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name: $name',style: Theme.of(context).textTheme.title,),
                Text('Profession: $profession'),
                Text('Message: $message'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color:Colors.black),
                  onPressed: () {
                    _showDialog(id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color:Colors.grey),
                  onPressed: () {
                    deleteData(id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  deleteData(String id) async{
     await ref.child('node-name').child(widget.getId).child(id).remove();
   setState(() {
     allData.clear();
     //DatabaseReference ref = FirebaseDatabase.instance.reference();                           //for global acces we declare above in class
     ref.child('node-name').child(widget.getId).once().then((DataSnapshot snap) {
       var keys = snap.value.keys;
       var data = snap.value;
       for(var key in keys){
         myData d =  myData(
             data[key]['name'],
             data[key]['message'],
             data[key]['profession'],
             data[key]['id'],
         );
         allData.add(d);
       }
       setState(() {
       print('length: ${allData.length}');
       });
     });
   });
  }

  _showDialog(String id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:  Text("Write Today's Task"),
          //content:  Text("How Are You"),
          content:  Row(
            children: <Widget>[
              Expanded(
//                flex: 1,
                  child:  TextFormField(
                 controller: _updateController,
                autofocus: true,
                decoration:  InputDecoration(
                  labelText: 'Update changes in the list',
                ),

//                    onSaved: (val){
//                   name = val;
//                    },

               ),
              ),
            ],
          ),
          actions: <Widget>[
         FlatButton(
              child:  Text("Update"),
              onPressed: () {
               updateData(id);
               Navigator.of(context).pop();
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
   updateData(String id) async{
    await ref.child('node-name').child(widget.getId).child(id).update({
      'name' : _updateController.text.toString(),
    });
    allData.clear();
    //DatabaseReference ref = FirebaseDatabase.instance.reference();                           //for global access we declare above in class
    ref.child('node-name').child(widget.getId).once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      for(var key in keys){
        myData d =  myData(
          data[key]['name'],
          data[key]['message'],
          data[key]['profession'],
          data[key]['id'],
        );
        allData.add(d);
      }
      setState(() {
        print('length: ${allData.length}');
      });
    });
  }
}
