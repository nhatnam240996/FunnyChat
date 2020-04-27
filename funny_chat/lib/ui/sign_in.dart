import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/view_model/sign_up_viewmodel.dart';
import 'package:provider/provider.dart';

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
  bool _visibility = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpViewModel>(context);
    return Scaffold(
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
                              obscureText: _visibility,
                              validator: (value) {
                                if (value.length < 8) {
                                  return "Mật khẩu phải có ít nhất 8 kí tự";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _visibility = !_visibility;
                                    });
                                  },
                                  child: Text(
                                    _visibility
                                        ? "show".toUpperCase()
                                        : "hide".toUpperCase(),
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
                        height: 16.0,
                      ),
                      Text(
                        provider?.error,
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
                          onPressed: () {
                            provider.signUp(
                                context, _email.text, _password.text);
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
        ],
      ),
    );
  }
}
