import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/models/chat/chat_room.dart';
import 'package:funny_chat/core/responsitory/api.dart';
import 'package:funny_chat/ui/chat.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TextEditingController _searchController = TextEditingController();
  Future<User> contact;

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
                  contact = Api.searchContact(value);
                },
              );
            },
          ),
          FutureBuilder(
              future: contact,
              builder: (context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: ListTile(
                      leading: CircleAvatar(),
                      title: Text(snapshot.data.name),
                      subtitle: Text(snapshot.data.email),
                      onTap: () async {
                        final Map map = {
                          "name": "room" + snapshot.data.id,
                          "uid": snapshot.data.id,
                        };
                        final result = await Api.createChatRoom(map);
                        print(result);
                        if (result is ChatRoom) {
                          // print("Here " + result.id);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Chat(result)));
                        } else {
                          print(result);
                        }
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text("No contacts yet"),
                  );
                }
              })
        ],
      ),
    );
  }
}