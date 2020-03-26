import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/responsitory/api.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/ui/home_page.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _validator = false;
  Color get colorNormal => const Color(0xFFCCF4F5);
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Đăng Kí".toUpperCase(),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  autovalidate: _validator,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(Icons.person_outline),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Tên không được để trống";
                                }
                                return null;
                              },
                              style: TextStyle(
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.mail_outline),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _email,
                              validator: (value) {
                                if (value.length < 8) {
                                  return "Email";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.lock_outline),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _password,
                              validator: (value) {
                                if (value.length < 8) {
                                  return "Mật khẩu phải có ít nhất 8 kí tự";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    "show".toUpperCase(),
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        height: 55.0,
                        child: FlatButton(
                          color: Colors.blueAccent,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0,
                                  title: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 122.0),
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ).timeout((Duration(milliseconds: 300)),
                                  onTimeout: () async {
                                final user = await Api.signIn(
                                  _name.text,
                                  _email.text,
                                  _password.text,
                                );
                                if (user is User) {
                                  Navigator.pop(context);
                                  await StorageManager.setObject("user", user);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomePage()));
                                } else {
                                  setState(() {
                                    // error = user;
                                    print(user);
                                    if (user == null) {
                                      error =
                                          "Có lỗi xảy ra vui lòng thử lại sau!";
                                    } else {
                                      error = user;
                                    }
                                  });
                                  Navigator.of(context).pop();
                                }
                              });
                              setState(() {
                                _validator = true;
                              });
                            }
                          },
                          child: Text(
                            "Sign in".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Visibility(
          //   visible: _isLoading,
          //   child: Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
