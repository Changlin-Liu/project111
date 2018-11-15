import 'package:flutter/material.dart';
import 'home.dart';
import 'package:reach/notification_list.dart';
import 'package:reach/notification_view.dart';
import 'forum_list.dart';
import 'package:reach/global.dart';
import 'package:reach/notification_create.dart';
import 'forum_view.dart';
import 'forum_create.dart';
import 'forum_comment.dart';
import 'chatroom.dart';


void main() {
  firebaseInit();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomePage(),
        //home: ForumListPage(),
        //home: ForumViewPage(),
        //home: NotificationViewPage(),
        //home: ForumCreatePage(),
        //home: ForumCommentPage(),
        routes:
        <String, WidgetBuilder>{
          '/notificationList': (BuildContext context) => NotificationListPage(),
          '/notificationView': (BuildContext context) => NotificationViewPage(),
          '/notificationCreate':(BuildContext context) => NotificationCreationPage(),
          '/forumList':(BuildContext context) => ForumListPage(),
          '/forumView':(BuildContext context) => ForumViewPage(),
          '/forumCreate':(BuildContext context) => ForumCreatePage(),
          '/forumComment':(BuildContext context) => ForumCommentPage(),
          '/chatroom':(BuildContext context) =>chatroomPage(),
          //'/notificationCreation': (BuildContext context) =>NotificationCreationPage(),
        });
  }


}