import 'package:flutter/material.dart';
import 'package:funny_chat/core/responsitory/api.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //leading: BackButton(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.mail_outline),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _name,
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
                          controller: _email,
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
                    onPressed: () {},
                    child: Text(
                      "Log in".toUpperCase(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign-in');
                        },
                        child: Text(
                          "register".toUpperCase(),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text(
                          "forgot password".toUpperCase(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
