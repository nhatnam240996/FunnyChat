import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/provider/register_phone_controller.dart';

class VerifyNumber extends StatefulWidget {
  @override
  _VerifyNumberState createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  final TextEditingController _otpController = TextEditingController();
  String _errorText;

  /// Check length of otp when user input
  int _optLength;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 32.0,
            ),
            Text(
                "Chúng tôi vừa gửi một mã xác thực gồm 6 chữ dố đến số điện thoại 0*****" +
                    RegisterPhoneController.instance.phone.substring(6)),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              autofocus: true,
              controller: _otpController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              onChanged: (onValue) {
                setState(() {
                  _optLength = onValue.length;
                });
              },
              decoration: InputDecoration(
                hintText: "Nhập OTP số điện thoại 0*****" +
                    RegisterPhoneController.instance.phone.substring(6),
                errorText: _errorText,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("00:59"),
                InkWell(
                  child: Text("Đổi số điện thoại"),
                  onTap: _changPhoneNumber,
                ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            RaisedButton(
              onPressed: _optLength == 6 ? _signInWithPhoneNumber : null,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Tiếp theo".toUpperCase(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _signInWithPhoneNumber() async {
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
    ).timeout((Duration(milliseconds: 300)), onTimeout: () async {
      try {
        final _authCredential = PhoneAuthProvider.getCredential(
          verificationId: RegisterPhoneController.instance.verificationId,
          smsCode: _otpController.text,
        );
        await FirebaseAuth.instance
            .signInWithCredential(_authCredential)
            .then((user) async {
          if (user != null) {
            final User userInf = User(
                uid: user.user.uid,
                name: "User-" + RegisterPhoneController.instance.phone,
                phone: RegisterPhoneController.instance.phone,
                photoUrl: "");
            await Firestore.instance
                .collection("users")
                .document("${user.user.uid}")
                .setData(userInf.toJson());

            await StorageManager.setObject("user", userInf.toJson());

            Navigator.of(context).pushNamedAndRemoveUntil(
              '/conversation-page',
              (Route<dynamic> route) => false,
            );
          } else {
            log("failure");
          }
        });
      } on PlatformException catch (e) {
        Navigator.pop(context);
        setState(() {
          _errorText = _getErrorMessage(e.code);
          log(_errorText);
        });
      }
    });
  }

  String _getErrorMessage(String e) {
    switch (e) {
      case "ERROR_INVALID_VERIFICATION_CODE":
        return "Mã OTP không đúng";
        break;
      default:
        return "Có lỗi đã xảy ra vui lòng thử lại sau";
    }
  }

  _changPhoneNumber() {
    Navigator.pushReplacementNamed(context, '/login-page');
  }
}
