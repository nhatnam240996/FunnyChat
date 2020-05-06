import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/models/chat/message.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/ui/chat_content.dart';

class ChatPage extends StatefulWidget {
  final Map map;
  const ChatPage(this.map);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  User user;
  var roomId;

  AnimationController _animationController;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      final bool hasUser = await StorageManager.checkHasKey("user");
      if (hasUser) {
        final currentUser = await StorageManager.getObjectByKey("user");
        setState(() {
          this.user = User.fromJson(currentUser);
        });
        roomId = _gennerateRoomId();
        await _addContactToListFriend();
      } else {}
    });
  }

  _addContactToListFriend() async {
    await Firestore.instance
        .collection("users")
        .document("${user.uid}")
        .collection("contacts")
        .document("${widget.map["phone"]}")
        .setData(
            {"uid": "${widget.map["uid"]}", "name": "${widget.map["name"]}"});
  }

  _gennerateRoomId() {
    var roomId;
    if (user.uid.hashCode > widget.map["uid"].hashCode) {
      roomId = utf8.encode("${user.uid + widget.map["uid"]}");
    } else {
      roomId = utf8.encode("${widget.map["uid"] + user.uid}");
    }

    return sha1.convert(roomId);
  }

  _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final Message _message = Message(
          user.uid,
          widget.map["uid"],
          _messageController.text,
          DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance
          .collection("conversations")
          .document("$roomId")
          .collection("message")
          .add(_message.toJson());
      _messageController.clear();
      _scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Stream<List<Message>> _streamMessage(int range) {
    var ref = Firestore.instance
        .collection("conversations")
        .document("$roomId")
        .collection("message")
        .orderBy("timetamp", descending: true)
        .limit(range);
    return ref.snapshots().map(
        (list) => list.documents.map((doc) => Message.fromJson(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: Icon(Icons.videocam),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/chat-video-page');
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _streamMessage(25),
                builder: (context, AsyncSnapshot<List<Message>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return NotificationListener(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          if (notification.metrics.pixels > 125) {
                            // load more message here

                          }
                        }
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return ChatContent(snapshot.data[index], user.uid);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              height: kToolbarHeight,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.ac_unit),
                    onPressed: _sendMessage,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Chat video

  /// TODO Load more list message

  /// TODO send Message

}
