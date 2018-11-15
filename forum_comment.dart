import 'global.dart';
import 'package:flutter/material.dart';

class ForumCommentPage extends StatefulWidget {
  @override createState() => ForumCommentState();
}
class ForumCommentState extends State {
  var images = [];
  var comment = '';

  var selectedCourse = roles.keys.first;
  var title2 = '';
  var content2 = '';



  @override
  Widget build(BuildContext context) {

    var widgets = <Widget>[
      TextField(
        decoration: InputDecoration(hintText: 'Title',),
        onChanged: (text) => setState(() => title2 = text),
      ),
      Divider(color: Colors.transparent,),
      TextField(
        decoration: InputDecoration(hintText: 'Content''\n''\n''\n''\n''\n',),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (text) => setState(() => content2 = text),
      ),
    ];


    var width = MediaQuery.of(context).size.width - 120;

    for (var f in images) {
      widgets.add(Divider(color: Colors.transparent,));
      widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.file(f, width: width),
              IconButton(icon: Icon(Icons.cancel), iconSize: 32.0,
                onPressed: () => setState(() => images.remove(f)),
              )
            ],
          )
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Comment'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.send), onPressed: () => post(),),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          Column(
              children: widgets
          )
        ],
      ),
    );


  }

  void post() {
    if(title2 !='' && content2 !='') {
      var course = forumSelection['course'];
      var key = forumSelection['key'];
      var ref = dbRef.child('courses/$course/forum/$key/comment').push();
      ref.set({
        'key': key,
        'title2': title2,
        'content2': content2,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'createdBy2': userID,
        'count': 1,
      });

    Navigator.pop(context);
    }else{
      var alert = AlertDialog(
        title: Text('Sorry'),
        content: Text('The comment can not be null.'),
      );
      showDialog(context: context, builder: (_)=>alert);
    }
  }

}
//}
