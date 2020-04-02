import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:funny_chat/core/global_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatViewModel with ChangeNotifier {
  IO.Socket socket;
  ChatViewModel() {
    ///  create socket and connet to server
    socket = IO.io(GlobalConfig.realDomain, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.io.options['extraHeaders'] = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    socket.connect();

    /// after create connection to server, send a signal enjoy room!
  }

  File _image;
  get image => _image;

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _image = image;
    notifyListeners();
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = image;
    notifyListeners();
  }
}
