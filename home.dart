import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reach/global.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() {
    return HomeState();
  }
}

class HomeState extends State {


  @override
  Widget build(BuildContext context) {
    if (userID != null)
      return menuScreen();
    else
      return splashScreen();
  }

  Widget splashScreen() {
    var title = 'REACH \n- \nGROUP 11';
    var content = '\nuniversity, teachers, \nclassmates and group mates.\n\n';

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(title, style: TextStyle(fontSize: 36.0, fontFamily:
              'Times New Roman'), textAlign: TextAlign.center,),

              Text(content, style: TextStyle(fontSize: 20.0, fontFamily:
              'Times New Roman'), textAlign: TextAlign.center,),

              IconButton(
                icon: Icon(Icons.assignment_ind),
                iconSize: 50.0,
                onPressed: () => signIn(context).then((success){
                  if (success) setState((){});
                }),
              ),
            ],
          ),
        )
    );
  }


  Widget menuScreen() {
    return Scaffold(

      appBar: AppBar(
        title: Text('REACH'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_box),
            onPressed: (){
              signOut();
              setState((){});
            },
          ),
        ],
      ),


      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.notifications, size: 48.0, color: Colors.white,),

                Text('Notifications',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),

              ],
            ),
            color: Colors.lightBlue ,
            onPressed:
                () => Navigator.pushNamed(context, '/notificationList'),

          ),

          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.forum, size: 48.0, color: Colors.white,),

                Text('Forum',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),

              ],
            ),
            color: Colors.amber ,
            onPressed:
                () => Navigator.pushNamed(context, '/forumList'),
          ),

          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.tag_faces, size: 48.0, color: Colors.white,),

                Text('Chatroom',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),

              ],
            ),
            color: Colors.greenAccent ,
            onPressed: () => Navigator.pushNamed(context, '/chatroom'),
          ),


        ], // <Widget>[]
      ), // GridView.count
    ); // Scaffold
  } // end of the menuScreen() method




}

