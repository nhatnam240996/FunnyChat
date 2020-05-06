import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/chat/message.dart';

class ChatContent extends StatefulWidget {
  final Message message;
  final String uid;
  ChatContent(this.message, this.uid);
  @override
  _ChatContentState createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // Visibility(
          //   visible: _visible,
          //   child: const Center(
          //     child: Text(
          //       "9h30'",
          //       style: TextStyle(fontSize: 14.0),
          //     ),
          //   ),
          // ),
          Row(
            mainAxisAlignment: widget.uid == widget.message.fromUid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              widget.uid == widget.message.fromUid
                  ? const SizedBox(
                      width: 64.0,
                    )
                  : Container(),
              Flexible(
                child: GestureDetector(
                  onTap: _getMoreDetail,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      widget.message.content,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              // widget.uid == widget.message.fromUid
              //     ? Container(
              //         height: 40,
              //         width: 40,
              //         decoration: const BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: Colors.orange,
              //         ),
              //       )
              //     : Container(),
            ],
          ),
          // Visibility(
          //   visible: _visible,
          //   child: Text(
          //     "Đã xem",
          //     style: TextStyle(fontSize: 12.0),
          //   ),
          // ),
        ],
      ),
    );
  }

  _getMoreDetail() {
    setState(() {
      _visible = !_visible;
    });
  }
}
