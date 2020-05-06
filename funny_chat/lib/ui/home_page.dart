import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/ui/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      } else {}
    });
  }

  _loadConversation() {
    Firestore.instance
        .collection("conversations")
        .document("uid1-uid2")
        .collection('123');
  }

  User user;
  final List<String> friends = [
    "Nam",
  ];
  PageController pageController = PageController();
  TextEditingController _searchController = TextEditingController();
  User contact;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            buildHomePageChat(context, pageController),
            buildContactPage(context, pageController),
          ]),
    );
  }

  Widget buildHomePageChat(
      BuildContext context, PageController pageController) {
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
                onDetailsPressed: () {
                  /// TODO
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Secret Chat'),
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text("Contact".toUpperCase()),
                onTap: () {
                  Navigator.of(context).pop();
                  pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                  // _pageController.nextPage(
                  //     duration: Duration(milliseconds: 300),
                  //     curve: Curves.easeIn);
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
            /// TODO
          });
        },
        child: Container(
          child: ListView(
            children: friends
                .map(
                  (e) => Dismissible(
                    key: Key("$e"),
                    child: ListTile(
                      onTap: () {},
                      leading: Container(
                        width: kToolbarHeight,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text("$e"),
                      subtitle: Text("How are you?"),
                      trailing: Text("9h45'"),
                    ),
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.notifications,
                          ),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {}
                      return false;
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildContactPage(BuildContext context, PageController pageController) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          pageController.animateToPage(0,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }),
      ),
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
                      contact = User.fromJson(data.documents[0].data);
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
