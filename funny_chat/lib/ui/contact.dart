import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/models/chat/chat_room.dart';
import 'package:funny_chat/core/responsitory/api.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/ui/chat.dart';
import 'package:funny_chat/ui/command/Popup.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TextEditingController _searchController = TextEditingController();
  User contact;
  User user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      final bool hasUser = await StorageManager.checkHasKey("user");
      if (hasUser) {
        final currentUser = await StorageManager.getObjectByKey("user");
        setState(() {
          this.user = User.fromJson(currentUser);
        });
      } else {
        print("error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search contacts",
            ),
            onSubmitted: (value) async {
              setState(
                () {
                  Popup.processingDialog(
                      context,
                      Api.searchContact(value).then((onValue) {
                        if (onValue.id == user.id) {
                          setState(() {
                            contact = null;
                          });
                        } else {
                          setState(() {
                            contact = onValue;
                          });
                        }
                      }));
                },
              );
            },
          ),
          Expanded(
              child: Container(
            child: contact == null
                ? Center(
                    child: Text("No contacts yet"),
                  )
                : ListTile(
                    leading: CircleAvatar(),
                    title: Text(contact.name),
                    subtitle: Text(contact.email),
                    onTap: () async {
                      final chatRoom = ChatRoom(
                        user.id,
                        contact.id,
                      ).toJson();
                      print(chatRoom);

                      final result = await Api.createChatRoom(chatRoom);
                      if (result != null) {
                        Navigator.pushNamed(context, "/chat",
                            arguments: {"roomId": result});
                      } else {
                        print("Somthing wrong");
                      }
                    },
                  ),
          )),

          // FutureBuilder(
          //     future: contact,
          //     builder: (context, AsyncSnapshot<User> snapshot) {
          //       if (snapshot.hasData && snapshot.data.id != user.id) {
          //         return Container(
          //           child: ListTile(
          //             leading: CircleAvatar(),
          //             title: Text(snapshot.data.name),
          //             subtitle: Text(snapshot.data.email),
          //             onTap: () async {
          //               final chatRoom = ChatRoom(
          //                 user.id,
          //                 snapshot.data.id,
          //               ).toJson();
          //               print(chatRoom);

          //               final result = await Api.createChatRoom(chatRoom);
          //               if (result != null) {
          //                 Navigator.pushNamed(context, "/chat",
          //                     arguments: {"roomId": result});
          //               } else {
          //                 print("Somthing wrong");
          //               }
          //             },
          //           ),

          //         );
          //       } else {
          //         return Center(
          //           child: Text("No contacts yet"),
          //         );
          //       }
          //     })
        ],
      ),
    );
  }
}
