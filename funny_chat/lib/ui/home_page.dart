import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/ui/contact.dart';
import 'package:funny_chat/core/responsitory/api.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/ui/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          ChatHome(),
          Contact(),
        ],
      ),
    );
  }
}

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
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
      } else {}
    });
  }

  final List<String> friends = ["Nam", "Bình", "Tính", "Lĩnh", "Nhơn", "Hùng"];
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
        ),
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
                        Provider.of<ThemeManager>(context, listen: false)
                            .changeTheme();
                      },
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
                leading: const Icon(Icons.lock_outline),
                title: const Text('Secret Chat'),
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text("Contact".toUpperCase()),
                onTap: () {
                  Navigator.of(context).pop();
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
                  await Api.logout();
                  Navigator.pushNamed(context, "/log-in");
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
}
