import 'package:flutter/material.dart';
import 'package:funny_chat/core/responsitory/api.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.person_outline),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _name,
                          style: TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.mail_outline),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.lock_outline),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _password,
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
                    height: 16.0,
                  ),
                  FlatButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      var reponse = Api.signIn(
                        _name.text,
                        _email.text,
                        _password.text,
                      );
                      print(reponse);
                    },
                    child: Text(
                      "Sign in".toUpperCase(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
