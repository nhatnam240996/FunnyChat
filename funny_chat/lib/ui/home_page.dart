import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/responsitory/api.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/ui/chat_home.dart';
import 'package:funny_chat/ui/contact.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  PageController _pageController = PageController();

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
        //Navigator.popUntil(context, ModalRoute.withName('/log-in'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search",
          ),
          readOnly: true,
          onTap: () {
            // showSearch(context: context, delegate: CustomSearch());
          },
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
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
                      onPressed: () {},
                    ),
                  ),
                ],
                accountName: Text(user?.name == null ? "User" : user.name),
                accountEmail: Text(user?.email == null ? "User" : user.email),
                onDetailsPressed: () {
                  //Navigator.pushNamed(context, "/search-contact");
                },
              ),
              ListTile(
                leading: Icon(Icons.perm_identity),
                title: Text("Contact".toUpperCase()),
                onTap: () {
                  Navigator.of(context).pop();
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                },
              ),
              ListTile(
                leading: const Icon(Icons.eject),
                title: const Text("Log out"),
                onTap: () async {
                  await Api.logout();
                  Navigator.pushNamed(context, "/log-in");
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
          child: SafeArea(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            ChatHome(),
            Contact(),
          ],
        ),
      )),
    );
  }
}
