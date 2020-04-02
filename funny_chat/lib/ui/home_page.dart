import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/models/chat/chat_room.dart';
import 'package:funny_chat/ui/command/Popup.dart';
import 'package:funny_chat/core/responsitory/api.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/ui/notification_page.dart';
import 'package:funny_chat/ui/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

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

  User user;
  final List<String> friends = ["Nam", "Bình", "Tính", "Lĩnh", "Nhơn", "Hùng"];
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
        actions: <Widget>[
          // Using Stack to show Notification Badge
          new Stack(
            children: <Widget>[
              new IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => NotificationPage()));
                  }),
              Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '10',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
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
              decoration: InputDecoration(
                suffix: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _searchController.clear());
                  },
                ),
                hintText: "Search contacts",
                contentPadding: EdgeInsets.only(left: 16.0),
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
                      subtitle: Text(contact.email),
                      onTap: () async {
                        final chatRoom = ChatRoom(
                          user.id,
                          contact.id,
                        ).toJson();
                        final result = await Api.createChatRoom(chatRoom);
                        if (result != null) {
                          Navigator.pushNamed(context, "/chat",
                              arguments: {"roomId": result});
                        } else {
                          print("Somthing wrong");
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
