import 'package:chatonline/widget/widgets.dart';
import 'package:flutter/material.dart';

import 'add_friend.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({ Key? key }) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar(
          title: const Text(
            'Friends',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(onPressed: (){
              nextScreen(context, AddFriend());
            },
            icon: const Icon(Icons.search),
            )
          ],
        bottom: TabBar(
          tabs: [
            SizedBox(
              height: 40,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.people),
                    SizedBox(width: 5),
                    Text("Friend List")
                  ]),
            ),
            SizedBox(
              height: 40,
              child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Icon(Icons.person_add),
                SizedBox(width: 5),
                Text("Friend Request")
              ]),
            ),
          ],
        ),),
      ),
    );
  }
}