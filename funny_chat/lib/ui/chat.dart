import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/chat/chat_room.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chat extends StatefulWidget {
  final ChatRoom chatRoom;
  Chat(this.chatRoom);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool showUtil = true;
  bool isTyping = false;
  TextEditingController _messageController = TextEditingController();
  //StreamController<String> _streamController;
  List<String> messages = [];
  IO.Socket socket;
  @override
  void initState() {
    //_streamController = StreamController<String>.broadcast();
    socket = IO.io('https://c229e0f8.ngrok.io', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    super.initState();
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
              child: StreamBuilder(
                //stream: channel.stream,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                  );
                },
              ),
              // child: StreamBuilder(
              //     stream: channel.stream,
              //     builder: (context, snapshot) {
              //       print(snapshot.data);
              //       return ListView(
              //         reverse: true,
              //         children: messages
              //             .map(
              //               (e) => Padding(
              //                 padding: const EdgeInsets.only(top: 4.0),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.end,
              //                   children: <Widget>[
              //                     const SizedBox(
              //                       width: 64.0,
              //                     ),
              //                     Flexible(
              //                       child: Container(
              //                         padding: EdgeInsets.symmetric(
              //                           horizontal: 8.0,
              //                           vertical: 8.0,
              //                         ),
              //                         decoration: BoxDecoration(
              //                           color: Colors.blue[500],
              //                           borderRadius:
              //                               BorderRadius.circular(15.0),
              //                         ),
              //                         child: Text(
              //                           "$e",
              //                           overflow: TextOverflow.clip,
              //                           textAlign: TextAlign.left,
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 18.0,
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                     const SizedBox(
              //                       width: 4.0,
              //                     ),
              //                     CircleAvatar(
              //                       backgroundColor: Colors.grey,
              //                       child: Icon(Icons.person_outline),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             )
              //             .toList(),
              //       );
              //     }),
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
                              // channel.sink.add(_messageController.text);
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
