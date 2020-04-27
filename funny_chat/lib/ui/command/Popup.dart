import 'package:flutter/material.dart';

class Popup {
  static processingDialog(context, Future callback) async {
    return await showDialog(
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
        final result = await callback;
        Navigator.pop(context);
        return result;
      },
    );
  }
}
