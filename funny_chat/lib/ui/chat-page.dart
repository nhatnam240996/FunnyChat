import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/models/chat/message.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/ui/chat_content.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

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
  bool isSendingImage = false;
  List<File> files;

  /// contain images send

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

  /// TODO choose multiple image

  Future<File> _chooseImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then(
      (value) async {
        if (value != null) {
          // setState(() {
          //   isSendingImage = true;
          // });

          /// should be show image here

          StorageReference storageReference = FirebaseStorage.instance
              .ref()
              .child('chats/${Path.basename(value.path)}');
          StorageUploadTask uploadTask = storageReference.putFile(value);
          await uploadTask.onComplete;
          await storageReference.getDownloadURL().then((fileURL) {
            log(fileURL);
            _sendMessage(true, urlImage: "$fileURL");

            /// percent is 100%
            return fileURL;
          });
        }
        return null;
      },
    );
    return null;
  }

  Future<File> _takePicture() async {
    await ImagePicker.pickImage(source: ImageSource.camera).then(
      (value) {
        if (value == null) {
          return null;
        }
        return value;
      },
    );
    return null;
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
        /// print(value.documents.length);
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

  _sendMessage(bool isSendImage, {String urlImage}) async {
    if (_messageController.text.isNotEmpty || isSendImage == true) {
      final Message _message = !isSendImage
          ? Message(user.uid, widget.map["uid"], _messageController.text,
              DateTime.now().millisecondsSinceEpoch.toString(), "String")
          : Message(user.uid, widget.map["uid"], urlImage,
              DateTime.now().millisecondsSinceEpoch.toString(), "image");
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
                            setState(() {
                              index = index + 10;
                              _loadMoreMessage = true;
                            });
                          }
                        }
                        return;
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
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _takePicture,
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _chooseImage,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.grey[800],
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.grey[800],
                          ),
                        ),
                        fillColor: Colors.grey[800],
                        filled: true,
                        hintText: "Aa",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage(false);
                    },
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
