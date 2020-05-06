import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/provider/register_phone_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController =
      TextEditingController(text: "");
  bool _validator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác thực số điện thoại"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 32.0,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  autovalidate: _validator,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    labelText: "Nhập số điện thoại",
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                      borderSide: BorderSide(
                          color: Colors.red,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                  ),
                  validator: (onValue) {
                    if (onValue.isEmpty) {
                      return "Nhập số điện thoại của bạn";
                    } else if (onValue.length < 10) {
                      return "Số điện thoại không đúng";
                    }
                    return null;
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                RaisedButton(
                  onPressed: _validateInput,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Tiếp theo".toUpperCase(),
                  ),
                )
              ],
            )),
      ),
    );
  }

  _validateInput() {
    if (_formKey.currentState.validate()) {
      _verifyNumber();
    } else {
      setState(() {
        _validator = true;
      });
    }
  }

  verificationCompleted(AuthCredential authCredential) {
    FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((AuthResult user) {
      if (user != null) {
        print("Log in success " + authCredential.providerId);
      } else {
        print("Somthing wrong");
      }
    });
  }

  verificationFailed(AuthException authException) {
    print(authException.message);
  }

  final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    print(verificationId);
    RegisterPhoneController.instance.verificationId = verificationId;
    print("Code sent:" + verificationId);
  };

  phoneCodeAutoRetrievalTimeout(String verificationId) {
    RegisterPhoneController.instance.verificationId = verificationId;
    print("Timeout" + verificationId);
  }

  Future _verifyNumber() async {
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: "+84" + _phoneNumberController.text,
            timeout: Duration(seconds: 10),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout)
        .then((onValue) {
      RegisterPhoneController.instance.phone = _phoneNumberController.text;
      FocusScope.of(context).unfocus();
      Navigator.pushNamed(context, '/verify-number');
    });
  }
}
