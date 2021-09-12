import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/providers/auth.dart';
import 'package:la_queen/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_authMode == AuthMode.Login) {
      await Provider.of<Auth>(context, listen: false)
          .logIn(_authData['email'], _authData['password'])
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
        print("Neuspješna prijava.");
        _showErrorAlert("prijava");
      });
    } else {
      await Provider.of<Auth>(context, listen: false)
          .singUp(_authData['email'], _authData['password'])
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
        print("Neuspješna registracija.");
        _showErrorAlert("registracija");
      });
    }
  }

  _showErrorAlert(String error) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.grey,
      title: Text("Neuspješna " + error),
      content: Text("Pokušajte ponovno."),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 13), primary: Color(0xffFFC592)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'U REDU',
          ),
        ),
      ],
    );

    CupertinoAlertDialog alertCuperino = CupertinoAlertDialog(
      title: Text("Neuspješna " + error),
      content: Text("Pokušajte ponovno."),
      actions: [
        CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'U redu',
            style: TextStyle(color: Color(0xff2d2d2d)),
          ),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS ? alertCuperino : alert;
      },
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      color: Color(0xff404040),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(color: Color(0xffA4A4A4)),
                  cursorColor: Color(0xffA4A4A4),
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return '- Mail nije dobrog formata.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  style: TextStyle(color: Color(0xffA4A4A4)),
                  cursorColor: Color(0xffA4A4A4),
                  decoration: InputDecoration(
                      labelText: 'Lozinka',
                      labelStyle: TextStyle(color: Colors.grey)),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return '- Lozinka mora saržavati minimalno 6 znakova.';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        style: TextStyle(color: Color(0xffA4A4A4)),
                        cursorColor: Color(0xffA4A4A4),
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(
                            labelText: 'Ponovljena lozinka',
                            labelStyle: TextStyle(color: Colors.grey)),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return '- Lozinke se ne podudaraju.';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  Platform.isIOS
                      ? CupertinoTheme(data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: CupertinoActivityIndicator())
                      : CircularProgressIndicator()
                else
                  Platform.isIOS
                      ? CupertinoButton(
                          color: Color(0xffFFC592),
                          onPressed: _submit,
                          child: Text(_authMode == AuthMode.Login
                              ? 'PRIJAVA'
                              : 'REGISTRACIJA'),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 13),
                              primary: Color(0xffFFC592)),
                          onPressed: _submit,
                          child: Text(_authMode == AuthMode.Login
                              ? 'PRIJAVA'
                              : 'REGISTRACIJA'),
                        ),
                Platform.isIOS
                    ? CupertinoButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                            '${_authMode == AuthMode.Login ? 'REGISTRACIJA' : 'PRIJAVA'}'),
                      )
                    : TextButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                            '${_authMode == AuthMode.Login ? 'REGISTRACIJA' : 'PRIJAVA'}'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
