import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonline/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/models.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {

  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text('Add Friends',);

  final TextEditingController _searchUserController = TextEditingController();
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: appBarTitle,
        actions: <Widget> [
          new IconButton(
            icon: actionIcon,
            onPressed: (){
              setState(() {
                if(this.actionIcon.icon==Icons.search){
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    controller: _searchUserController,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                      // border: OutlineInputBorder(),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.fromLTRB(4, 14, 4, 0),
                    ),
                    onChanged: (text) {
                      setState(() {
                        searchString = text;
                      });
                    },
                  );

                }
                else{
                  handleSearchEnd();
                }
              });
            },

          )
        ],
      ),
      body: listUser(),
    );
  }

  handleSearchEnd(){
    setState(() {
      this.appBarTitle = new Text("Add Friends");
      this.actionIcon = new Icon(Icons.search);
      searchString = '';
      _searchUserController.clear();
    });
  }

  listUser(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('userID',
          isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData){
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(), //not allow to top scroll
              shrinkWrap: true, //popup
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                UserModel userModel = UserModel.fromJson(snapshot.data!.docs[index].data() as
                Map<String, dynamic>);
                if(userModel.userName!.toLowerCase().contains(searchString.toLowerCase())) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: ClipOval(
                        child: userModel.image!.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: userModel.image!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                            : Image.asset("assets/images/user_img.png",
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(userModel.userName!),
                      trailing: Container(
                        width: 36,
                        height: 36.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(36),color:Colors.blue.shade400),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          splashRadius: 22.0,
                          onPressed: () {
                          },
                          icon: const Icon(Icons.person_add,size:  18.0,),color: Colors.white,),
                      ),
                    ),
                  );
                }
              }
          );
        }
        return const Center(
          child: Text('No found user'),
        );
      },
    );
  }

}