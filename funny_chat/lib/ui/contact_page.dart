import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/storage_manager.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  User contact;
  User user;
  TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (callback) async {
        final bool hasUser = await StorageManager.checkHasKey("user");
        if (hasUser) {
          final currentUser = await StorageManager.getObjectByKey("user");
          setState(() {
            this.user = User.fromJson(currentUser);
          });
        } else {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              onChanged: (onValue) {
                setState(() {
                  contact = null;
                });
              },
              decoration: InputDecoration(
                suffix: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _searchController.clear());
                  },
                ),
                hintText: "Search phone number",
                contentPadding: EdgeInsets.only(left: 16.0),
              ),
              onSubmitted: (value) async {
                try {
                  Firestore.instance
                      .collectionGroup("users")
                      .where("phone", isEqualTo: value)
                      .snapshots()
                      .listen((data) {
                    print(data.documents[0].data);
                    setState(() {
                      if (data?.documents[0]?.data["uid"] != user.uid) {
                        contact = User.fromFirebase(data.documents[0]);
                      }

                      /// TODO here
                    });
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            Container(
              child: contact == null
                  ? Center(
                      child: Text("No contacts yet"),
                    )
                  : ListTile(
                      leading: Container(
                        width: kToolbarHeight,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(contact.name),
                      subtitle: Text("Nhấn để bắt đầu cuộc trò chuyện"),
                      onTap: () async {
                        Navigator.pushNamed(
                          context,
                          "/chat-page",
                          arguments: contact.toJson(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
