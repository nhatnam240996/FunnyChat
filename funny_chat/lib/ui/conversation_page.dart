import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/models/chat/room_id.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'dart:math' as math;
import 'package:funny_chat/ui/theme/theme_manager.dart';
import 'package:funny_chat/ui/widgets/last_message.dart';
import 'package:provider/provider.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  User user;

  @override
  void initState() {
    super.initState();
  }

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
      appBar: AppBar(
        title: Text("Funny Chat"),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(),
                otherAccountsPictures: <Widget>[
                  Transform.rotate(
                    angle: math.pi / 6,
                    child: IconButton(
                      icon: const Icon(
                        Icons.brightness_2,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final darkTheme =
                            Provider.of<ThemeManager>(context, listen: false)
                                .darkTheme;
                        await StorageManager.setStorage(
                            "darkTheme", !darkTheme);
                        Provider.of<ThemeManager>(context, listen: false)
                            .changeTheme(!darkTheme);
                      },
                    ),
                  ),
                ],
                accountName: Text(user?.name == null ? "User" : user.name),
                accountEmail: Text("user"),
                onDetailsPressed: () {},
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Secret Chat'),
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text("Contact".toUpperCase()),
                onTap: () {
                  /// Close drawer and navigator to contact page
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/contact-page');
                },
              ),
              ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text("Add group"),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Setting"),
              ),
              ListTile(
                leading: const Icon(Icons.eject),
                title: const Text("Log out"),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      title: Container(
                        margin: EdgeInsets.symmetric(horizontal: 122.0),
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ).timeout(Duration(milliseconds: 100), onTimeout: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login-page', (Route<dynamic> route) => false);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text("About FChat"),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {
            /// TODO refresh page here!
          });
        },
        child: Container(
          child: StreamBuilder<List<User>>(
            stream: _streamConversationPages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/chat-page',
                            arguments: snapshot.data[index].toJson(),
                          );
                        },
                        leading: Container(
                          width: kToolbarHeight,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text("${snapshot?.data[index]?.name}"),
                        subtitle: LastMessage(
                          data: RoomId(user.uid, snapshot?.data[index]?.uid)
                              .toJson(),
                        ),
                        trailing: Text("9h45'"),
                      );
                    });
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Stream<List<User>> _streamConversationPages() {
    final _listFriend = Firestore.instance
        .collection("users")
        .document("${user?.uid}")
        .collection('contacts');
    return _listFriend.snapshots().map((listUser) =>
        listUser.documents.map((e) => User.fromFirebase(e)).toList());
  }
}
