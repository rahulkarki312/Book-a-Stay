import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_exceptions.dart';
import 'package:video_player/video_player.dart';
import 'package:blur/blur.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://media.istockphoto.com/id/966113438/video/coconut-palm-trees-crowns-against-blue-sunny-sky-perspective-view-from-the-ground.mp4?s=mp4-640x640-is&k=20&c=TTDqd3rWhgVcbAGzlT8PTTuEdOAHA8wgiEJJOykuvFg='))
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0);
        //Ensure the first frame is shown after the value is initialized
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: _controller.value.size.width ?? 0,
                height: _controller.value.size.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          // Container(
          //   decoration: const BoxDecoration(
          //     color: Colors.white,
          //   ),
          // ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.10,
                      margin: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 70),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 14.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.transparent,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Book a stay',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1, child: AuthCard()),
                ],
              ),
            ),
          ),
          const Positioned(
              left: 10,
              bottom: 35,
              child: Text(
                "Book Your Dream Hotel At Best Price",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontSize: 18),
              )),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  // const AuthCard({
  //  required Key key,
  // }) : super(key: key);

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
    'firstname': '',
    'lastname': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 400,
        ));
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // _heightAnimation.addListener(() => setState(() {}));
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _controller.dispose();
  // }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("An Error Occured !"),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(), child: Text('Okay'))
            ],
          );
        });
  }

  Future<void> _submit({loginAsAdmin = false}) async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        if (loginAsAdmin) {
          await Provider.of<Auth>(context, listen: false)
              .loginAdmin(_authData['email']!, _authData['password']!);
        }
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email']!,
            _authData['password']!,
            _authData['firstname']!,
            _authData['lastname']!);
      }
    } on HttpException catch (error) {
      var errorMessage = "Authentication failed";
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "Email already in use.";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "Invalid email address";
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = "Password is too weak.";
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = "The email has not been registered";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "The password you entered is wrong";
      }
      _showErrorDialog(errorMessage);
      setState(() => _isLoading = false);
    } catch (error) {
      // var errorMessage = error;
      // "Could not authenticate you, please try again later.";
      _showErrorDialog(
          "Could not authenticate you, please try again later (Check your Internet Connection)");
      setState(() => _isLoading = false);
    }

    // setState(() {
    //   _isLoading = false;
    // });
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
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        height: _authMode == AuthMode.Signup ? 420 : 260,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 300),
        // constraints: BoxConstraints(minHeight: _heightAnimation.value.height),
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'E-Mail',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value as String;
                  },
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value as String;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 80 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 220 : 0,
                  ),
                  duration: const Duration(milliseconds: 400),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          enabled: _authMode == AuthMode.Signup,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          enabled: _authMode == AuthMode.Signup,
                          decoration: const InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Your First Name!';
                                  }
                                }
                              : null,
                          onSaved: (value) {
                            _authData['firstname'] = value as String;
                          },
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          enabled: _authMode == AuthMode.Signup,
                          decoration: const InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Your Last Name!';
                                  }
                                }
                              : null,
                          onSaved: (value) {
                            _authData['lastname'] = value as String;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
                if (_authMode == AuthMode.Login)
                  TextButton(
                    onPressed: () {
                      _submit(loginAsAdmin: true);
                    },
                    child: const Text("LOG IN AS ADMIN"),
                  )
              ],
            ),
          ),
        ),
      ).frosted(
          blur: 1,
          borderRadius: BorderRadius.circular(10),
          frostColor: Colors.transparent,
          padding: EdgeInsets.all(0)),
    );
  }
}
