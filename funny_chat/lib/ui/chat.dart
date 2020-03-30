import 'package:flutter/material.dart';
import 'package:funny_chat/core/global_config.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/models/chat/join.dart';
import 'package:funny_chat/core/models/chat/message.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chat extends StatefulWidget {
  final Map data;
  Chat(this.data);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool showUtil = true;
  bool isTyping = false;
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  User user;
  List<String> messages = [];
  IO.Socket socket;
  @override
  void initState() {
    //_streamController = StreamController<String>.broadcast();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Get user from local
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      final bool hasUser = await StorageManager.checkHasKey("user");
      if (hasUser) {
        final currentUser = await StorageManager.getObjectByKey("user");
        setState(() {
          this.user = User.fromJson(currentUser);
        });
      } else {
        print('Something Wrong');
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: <Widget>[
          /// content of messages
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: ListView(
                reverse: true,
                children: messages
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const SizedBox(
                              width: 64.0,
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[500],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Text(
                                  "$e",
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person_outline),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          /// input message and send button
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: showUtil,
                  child: Container(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.photo_library),
                          color: Colors.blueAccent,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_voice),
                          color: Colors.blueAccent,
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: TextField(
                      controller: _messageController,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: "Nhập tin nhắn",
                        contentPadding: const EdgeInsets.only(
                            left: 16.0, top: 8.0, bottom: 8.0),
                        suffixIcon: IconButton(
                          icon: isTyping
                              ? Icon(Icons.send)
                              : Icon(Icons.tag_faces),
                          onPressed: () {
                            if (_messageController.text.isNotEmpty) {
                              socket = IO.io(
                                  GlobalConfig.realDomain, <String, dynamic>{
                                'transports': ['websocket'],
                                'autoConnect': false,
                              });

                              socket.io.options['extraHeaders'] = {
                                'Content-type': 'application/json',
                                'Accept': 'application/json'
                              };
                              socket.connect();
                              // final messenger = Message(widget.data["roomId"],
                              //     user.id, _messageController.text);

                              final join = Join(
                                widget.data["roomId"],
                                UserInf(
                                  user.id,
                                  user.name,
                                ),
                              ).toJson();
                              socket.emitWithAck("join", join, ack: (onValue) {
                                print(onValue);
                              });

                              /// send message

                              socket.once("messenger", (value) {
                                print(value);
                              });

                              socket.on("${widget.data["roomId"]}", (onValue) {
                                print(onValue);
                              });

                              WidgetsBinding.instance.addPostFrameCallback(
                                  (_) => _messageController.clear());
                            }
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            showUtil = true;
                            isTyping = false;
                          });
                        } else {
                          setState(() {
                            isTyping = true;
                            showUtil = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
