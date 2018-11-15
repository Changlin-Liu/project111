import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reach/global.dart';


class ForumListPage extends StatefulWidget {
  @override
  createState() =>ForumListState();
  }



class ForumListState extends State {


  var canCreate = false;
  var nMap = {};


  @override
  void initState() {
    super.initState();
    getRoles().then((_) => getForumList());
  }

  void getForumList() {
    Set roleSet, courseSet;
    if (roles != null) {
      roleSet = roles.values.toSet();
      courseSet = roles.keys.toSet();
    } else {
      roleSet = Set();
      courseSet = Set();
    }
    courseSet.add('ALL');
    canCreate = roleSet.contains('teacher')
        || roleSet.contains('administrator')
        || roleSet.contains('student');
    for (var c in courseSet) {
      var nRef = dbRef.child('courses/$c/forum');
      nRef.onValue.listen((event) {
        if (event.snapshot.value == null) nMap.remove(c);
        else nMap[c] = (event.snapshot.value as Map).values.toList();
        if (mounted) setState(() {});
      });
    }
  }
  @override Widget build(BuildContext context) {

    var widgetList = <Widget>[];

    var data = List();
    for (List c in nMap.values)
      data.addAll(c);
    data.sort((a, b) => b['createdAt'] - a['createdAt']);
    // for (var i = 1; i <= 20; i++) {
    // var item = 'Notification $i';
    for (var i=0; i<data.length; i++){
      var item = data[i];
      var title = item['title'];
      var course = item['course'];
      var datetime = DateTime.fromMillisecondsSinceEpoch(item['createdAt']);
      var createdAt = DateFormat('EEE, MMMM d, y H:m:s',
          'en_US').format(datetime);
      var content = item['content'];
      var images = item['images'];

      widgetList.add(
          SizedBox(
              width: MediaQuery.of(context).size.width,
              //height: 200.0,
              child: Card(
                  color: Colors.white,
                  elevation: 3.0,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListTile(

                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Divider(color: Colors.transparent, height: 9.0,),
                                Text(title,
                                  style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.bold),),
                                Divider(color: Colors.transparent, height: 3.0,),
                                Text(createdAt,
                                  style: TextStyle(fontSize: 12.0, color: Colors.blueGrey),),
                                Divider(color: Colors.transparent, height: 10.0,),
                                Divider(color: Colors.transparent, height: 10.0,),
                              ],

                            ),
                            subtitle: Text(content, style: TextStyle(fontSize: 15.0),),


                            onTap: () {
                              forumSelection = item;
                              Navigator.pushNamed(context, '/forumView');
                            }
                            ),
                        ListTile(
                          title: Column(
                            children: <Widget>[
                              Text('$course                   ''& comments',
                                style: TextStyle(fontSize: 13.0,color: Colors.grey,),
                                textAlign: TextAlign.left,
                              ),

                            ],
                          ),
                          trailing:IconButton(
                            iconSize: 25.0,
                            alignment: Alignment.bottomLeft,
                            icon: Icon(Icons.more_horiz),
                            onPressed: () => Navigator.pushNamed(context, '/forumView'),),

                        ),

              ]
                  ),
              ),


          )

      );
    }

    return Scaffold(

      floatingActionButton: (canCreate)?
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.pushNamed(context, '/forumCreate'),
      ) : null,

      appBar: AppBar(title: Text('Forums'),),
      body: ListView(
        children: widgetList,
        padding: EdgeInsets.all(20.0),
      ),


    );

}
}