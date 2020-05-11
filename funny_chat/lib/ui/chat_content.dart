import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/chat/message.dart';

class ChatContent extends StatelessWidget {
  final Message message;
  final String uid;
  ChatContent(this.message, this.uid);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: uid == message.fromUid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              uid == message.fromUid
                  ? const SizedBox(
                      width: 64.0,
                    )
                  : const SizedBox(),
              message.type == "String"
                  ? Flexible(
                      child: GestureDetector(
                        onTap: null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            message.content,
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        message.content,
                        height: 200,
                      ),
                    ),
              const SizedBox(
                width: 8.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // _getMoreDetail() {
  //   setState(() {
  //     _visible = !_visible;
  //   });
  // }
}
