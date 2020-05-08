import 'dart:convert';
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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> listMessage;
  bool _loadMoreMessage = false;
  int index = 25;
  bool _showWaiting = false;

  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      final currentUser = await StorageManager.getObjectByKey("user");
      setState(() {
        this.user = User.fromJson(currentUser);
      });
      roomId = _gennerateRoomId();
      _addContactToListFriend();
    });
  }

  _addContactToListFriend() async {
    /// check user has in list friend if not add to list
    await Firestore.instance
        .collection("users")
        .document("${user.uid}")
        .collection("contacts")
        .where("uid", isEqualTo: widget.map["uid"])
        .getDocuments()
        .then((value) {
      if (value.documents.length == 0) {
        print(value.documents.length);
        Firestore.instance
            .collection("users")
            .document("${user.uid}")
            .collection("contacts")
            .document("${widget.map["phone"]}")
            .setData({
          "uid": "${widget.map["uid"]}",
          "name": "${widget.map["name"]}"
        });
      }
    });
  }

  _gennerateRoomId() {
    List<int> _roomId;
    final String myId = user.uid;
    final String friendId = widget.map["uid"];
    if (myId.hashCode > friendId.hashCode) {
      _roomId = utf8.encode("${myId + friendId}");
    } else {
      _roomId = utf8.encode("${friendId + myId}");
    }
    return sha1.convert(_roomId);
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
    final ref = Firestore.instance
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
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFFF),
                ),
              ),
              child: const Icon(Icons.videocam),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/chat-video-page');
            },
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _loadMoreMessage
                    ? _streamMessage(index)
                    : _streamMessage(25),
                builder: (context, AsyncSnapshot<List<Message>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    _showWaiting = true;
                  }
                  if (snapshot.connectionState == ConnectionState.active) {
                    _showWaiting = false;
                  }

                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    /// get message from firebase then add to list
                    listMessage = snapshot.data;
                    return NotificationListener(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          if (notification.metrics.pixels > 125) {
                            debugPrint("Scroll to the top");
                            setState(() {
                              index = index + 10;
                              _loadMoreMessage = true;
                            });
                          }
                        }
                      },
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Visibility(
                              visible: _showWaiting,
                              child: Container(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: const CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          ListView.builder(
                            addAutomaticKeepAlives: true,
                            primary: false,
                            controller: _scrollController,
                            reverse: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ChatContent(listMessage[index], user.uid);
                            },
                          ),
                        ],
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
                  // IconButton(
                  //   icon: const Icon(Icons.ac_unit),
                  //   onPressed: _sendMessage,
                  // ),
                  IconButton(icon: Icon(Icons.camera_alt), onPressed: null),
                  IconButton(icon: Icon(Icons.camera_alt), onPressed: null),
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        filled: true,
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
