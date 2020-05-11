import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LastMessage extends StatefulWidget {
  final Map data;

  const LastMessage({Key key, this.data}) : super(key: key);

  @override
  _LastMessageState createState() => _LastMessageState();
}

class _LastMessageState extends State<LastMessage> {
  var roomId;
  @override
  void initState() {
    super.initState();
    roomId = _gennerateRoomId();
  }

  _gennerateRoomId() {
    var _roomId;
    String myId = widget.data["myId"];
    String frinedId = widget.data["frinedId"];
    if (myId.hashCode > frinedId.hashCode) {
      _roomId = utf8.encode("${myId + frinedId}");
    } else {
      _roomId = utf8.encode("${frinedId + myId}");
    }
    return sha1.convert(_roomId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("conversations")
            .document("$roomId")
            .collection("message")
            .limit(1)
            .orderBy("timetamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length > 0) {
              return Text(
                "${snapshot?.data?.documents[0]?.data["content"]}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
            return Container();
          }
          return Container();
        });
  }
}
