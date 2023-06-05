import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/auth.dart';

// import '../Models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      //the transform argument in a container allows us to transform how container is prsented, allows to rotate,move,scale the container
                      // this trnasform takes Matrix4 and tyhis class allows us to describe rotation,scaling and offset
                      //the ..operator is a special operator for the dart pogramming language
                      // this operator is used to return what the previous method is reurning
                      // for example the translate emthod is returning void but for the trasform argument we would need Matrix4 hence we use the .. operator to return
                      // to return what the rotationZ method which is matrix4
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin adds some methods and let's our widget know when a frame update is due aimations need this information to play smoothly
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  late AnimationController controller;
  late Animation<Size> heightAnimation;
  late Animation<double> opacityAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    // we define a animationcontroller named controller for the animation
    // while definign the animation controller we ahve the parameter vsync
    // this vsync is used to give the controller a pointer at the widget which it must watch and if thewidget comes on the screen then only the animation should play , heling in optimizing the app for performace
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    //we could also speciyfyt eh reverse duration if we want the fwd and reverse duration to be different be default they are te same

    //Tween is an ibjectthat relates the two values it is originated from between i forms a sort of relation
    // here Tween has only the info on the animation that hwow it would start and end for example we have seen that the container height would change from 260 to 320 when the signup method is selected
    // then we use this info defined in tween to animate the object
    ////we mostly use curvedAnimation which consider it's parent as the controller and the curve to be experimental it could be Curves.__ what you find suitable for the job
    heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
    // add the listener to call set state andc change frame
    //heightAnimation.addListener(() => setState(() {}));
    //now instead of manually managing the listener we would be using a built in animatedbuilder widget
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String Message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Text(Message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("OK"))
          ],
        );
      },
    );
  }

  void _submit() async {
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
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
            _authData["email"].toString(), _authData["password"].toString());
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
            _authData["email"].toString(), _authData["password"].toString());
      }
      // Navigator.of(context).pushReplacementNamed("products-overview"); now this would work but hthere's a problem in user experience ie the user would always have to login ie visit the auth screen
      // we want that there should be some buffer in between
    }
    // the on keyword is used to catch a specific error whcih is thrown
    //for exampe we are throwing our own httpexception and using on keyword for the same
    catch (error) {
      print(error);
      _showErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    // here we switch the mode hence we would end and sstart the animation here
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      // instead of animated we could also use animated cotainer
      //If we are animating some properties of the contaier say size or color
      // we could use the animatedcontainer widget whcihc is way efficient and does all the heave lifting of mainintaing a controller in itself
      //we just need to define the duration and curve and then the change which is to be animated rest could be in the child parament
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
        //so we can see that we don't have to maintain a controller or callistener w c just need to redefine the original contraints which
        //a normal container would hard switch that's understood by this animated container and would animate this itself without much work
        height: _authMode == AuthMode.Signup ? 320 : 260,
        //height: heightAnimation.value.height,
        // constraints: BoxConstraints(minHeight: heightAnimation.value.height),
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  FadeTransition(
                    opacity: opacityAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  )
                else
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    ),
                  ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    //here the child is of the animated builder widget which means that it won't rebuild upon build running again as it's constant

    // Container(
    //   // height: _authMode == AuthMode.Signup ? 320 : 260,
    //   height: heightAnimation.value.height,
    //   constraints: BoxConstraints(minHeight: heightAnimation.value.height),
    //   width: deviceSize.width * 0.75,
    //   padding: EdgeInsets.all(16.0)
  }
}
