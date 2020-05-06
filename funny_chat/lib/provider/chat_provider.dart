import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:funny_chat/core/models/chat/message.dart';

class ChatProvider with ChangeNotifier {
  // mode = 1 mean get last message and != 1 meaning load list Message
  Stream<List<Message>> loadMessage(String roomId, int mode) {
    var ref = Firestore.instance
        .collection("conversations")
        .document("$roomId")
        .collection("message")
        .limit(mode);
    return ref.snapshots().map(
        (list) => list.documents.map((doc) => Message.fromJson(doc)).toList());
  }
}
