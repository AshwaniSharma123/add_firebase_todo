import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerClass extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('shimmer'),
//      ),
      body: Center(
        child: ShimmerList(),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        separatorBuilder: (context,index)=> Divider(
          color: Colors.grey,
        ),
        itemCount: 7,
          itemBuilder: (BuildContext context ,int index){
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[300],
              child: ShimmerLayout(),
             ),
            );
           },
          ),
         );
  }
}

class ShimmerLayout extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    double containerWidth = 280;
    //double containerHeight = 50;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            color: Colors.grey,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 20,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5,),
              Container(
                height: 15,
                width: containerWidth*0.90,
                color: Colors.grey,
              ),
              SizedBox(height: 5,),
              Container(
                height: 13,
                width: containerWidth * 0.75,
                color: Colors.grey,
              ),
              SizedBox(height: 5,),
            ],
          ),
        ],
      ),
    );
  }
}