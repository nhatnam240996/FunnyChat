import 'package:flutter/material.dart';
import 'package:funny_chat/core/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = false;
  bool _validator = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                autovalidate: _validator,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.mail_outline),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Email invalid";
                              }
                              return null;
                            },
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(),
                            style: const TextStyle(
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
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Password must be at least 8 charater";
                              }
                              return null;
                            },
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    })),
                            style: const TextStyle(
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Consumer<LoginViewModel>(
                      builder: (context, provider, child) {
                        return Text(
                          provider.error,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    FlatButton(
                      color: Colors.blueAccent,
                      onPressed: () {
                        final Map data = {
                          "email": _emailController.text,
                          "password": _passwordController.text,
                        };
                        provider.signIn(data, context);
                      },
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
                          onPressed: () async {},
                          child: Text(
                            "forgot password".toUpperCase(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
