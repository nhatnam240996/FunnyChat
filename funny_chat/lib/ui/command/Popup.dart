import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Popup {
  static processingDialog(context, AsyncCallback callback()) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 122.0),
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    ).timeout(
      (Duration(milliseconds: 300)),
      onTimeout: () async {
        callback();
      },
    );
  }
}
