import 'dart:async';

import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool showUtil = true;
  bool isTyping = false;
  TextEditingController _messageController = TextEditingController();
  StreamController<String> _streamController;
  List<String> messages = [];

  void sendMessage(String message) {
    _streamController.add(message);
    messages.add(message);

    /// after send message should be clear
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _messageController.clear());
  }

  @override
  void initState() {
    _streamController = StreamController<String>.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _messageController.dispose();
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
              child: StreamBuilder<String>(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    return ListView(
                      reverse: true,
                      children: messages
                          .map(
                            (e) => Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                // Expanded(
                                //   child: const SizedBox(
                                //     width: double.infinity,
                                //   ),
                                // ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
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
                          )
                          .toList(),
                    );
                  }),
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
                            sendMessage(_messageController.text);
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
