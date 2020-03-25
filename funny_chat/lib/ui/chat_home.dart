import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.redAccent,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                  decoration: BoxDecoration(color: Colors.yellow),
                  child: Text(
                    "hihi",
                    softWrap: false,
                    //overflow: TextOverflow.clip,
                    //textAlign: TextAlign.left,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
