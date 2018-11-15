import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:reach/global.dart';


class ForumViewPage extends StatefulWidget {
  @override createState() => ForumViewState();
}


class ForumViewState extends State {
  var images = [];
  var nList = [];
  var canCreate = false;
  @override
  void initState() {
    super.initState();
    getRoles().then((_) => getForumListComment(forumSelection["key"]
    ));
    if (forumSelection['images'] != null)
      for (var url in forumSelection['images']) {
        http.get(url).then((response) {
          images.add(response.bodyBytes);
          if (mounted)
            setState(() {});
        });
      }

  }
//get the images in view content


////////////////////////////////////////////////////////////////////////////////



  void getForumListComment(String key) {
    Set roleSet, forumSet;
    if (roles != null) {
      roleSet = roles.values.toSet();
      forumSet = roles.keys.toSet();
    } else {
      roleSet = Set();
      forumSet = Set();
    }
    forumSet.add('ALL');
    canCreate = roleSet.contains('teacher')
        || roleSet.contains('administrator')
        || roleSet.contains('student');

      var course = forumSelection['course'];
      var nRef = dbRef.child('courses/$course/forum/$key/comment');

      nRef.onValue.listen((event) {
        if (event.snapshot.value != null)
        nList = (event.snapshot.value as Map).values.toList();
        if (mounted) setState(() {});
      });
    }



// add a comment
////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    var data = forumSelection;
    var title = data['title'];
    var course = data['course'];
    var content = data['content'];
    var createdBy = data['createdBy'];
    var datetime = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
    var createdAt = DateFormat('EEE, MMM d, y H:m:s', 'en_US').format(datetime);

    var childWidgets = <Widget>[
      Text(title,
        style: TextStyle(color: Colors.blue,fontSize: 20.0,),
        textAlign: TextAlign.left,),
      Divider(color: Colors.transparent,),
      Text(content),
    ];
// Main body of forum

    var width = MediaQuery.of(context).size.width - 120;

    for (var i in images) {
      childWidgets.add(Divider(color: Colors.transparent));
      childWidgets.add(Image.memory(i, width: width));
      childWidgets.add(Divider(color: Colors.transparent));
      childWidgets.add(Divider(color: Colors.transparent));
      childWidgets.add(Divider(color: Colors.transparent));
      childWidgets.add(Divider(color: Colors.grey));
    }



/////////////////////////////////////////////////////////////////////////////////////////////


    var widgetComment =<Widget>[
      Text('Comment',
        style: TextStyle(color: Colors.blue,fontSize: 20.0),textAlign: TextAlign.left,),
      IconButton(
        icon:
        Icon(Icons.add_circle ),
        onPressed: ()=>Navigator.pushNamed(context, '/forumComment'),
      ),

      //Divider(color: Colors.transparent,),
    ];

    var data2 = List();

        data2.addAll(nList);
        data2.sort((a, b) => b['createdAt'] - a['createdAt']);

      for (var i=0; i<data2.length; i++) {
        var item = data2[i];
        var title2 = item['title2'];
        var content2 = item['content2'];
        var createdBy2 = item['createdBy2'];

      widgetComment.add(

      Container(
            padding: EdgeInsets.all(0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                  '$userID/images'),
                              radius: 20.0,
                            ),

                          ]
                      ),
                      title: Text(createdBy2),
                      subtitle: Text('$title2: $content2',),
                      trailing: Icon(
                        Icons.favorite
                      ),
                    )
          ]
                )

                    )
                  ],
                )
      ),

      );}

//main body of comment
//////////////////////////////////////////////////////////////////////////////////


    return Scaffold(
      appBar: AppBar(
        title: Text(course),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Column(
            children: childWidgets,),
          Column(
            children: widgetComment,),
        ],
      ),
      persistentFooterButtons: <Widget>[
        Text('by $createdBy''\n'
            '$createdAt',
          textAlign: TextAlign.left,),
        (['teacher', 'administrator'].contains(roles[course]))?
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () => delete(),
        ):null,
      ],
    );

  }

////////////////////////////////////////////////////////////////////////////////


  void delete() {
    var key = forumSelection['key'];
    var course = forumSelection['course'];
    dbRef.child('courses/$course/forum/$key').remove();
    for (var i = 0; i < images.length; i++)
      storageRef.child('$key/$i').delete();
    Navigator.pop(context);
  }
}

