import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codev/providers/sign_in_info.dart';
import 'package:codev/screens/endquiz_screen.dart';
import 'package:codev/screens/main_screen.dart';
import 'package:codev/screens/quiz_screen.dart';
import 'package:codev/screens/tasks_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/style.dart';
import '../providers/auth.dart';
import '../screens/signup_screen.dart';

enum AuthMode { Signup, Login }

enum Status { SUCESS, FAIL }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);

    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              /* Upper half*/

              Container(
                  height: safeHeight * 0.45,
                  color: const Color.fromRGBO(243, 250, 255, 1),
                  padding: EdgeInsets.all(deviceSize.width * 0.08),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: deviceSize.width * 0.35,
                          height: deviceSize.width * 0.35,
                          child: const Image(
                              image: AssetImage('assets/img/logo.png')),
                        ),
                        Text(
                          "CoDev",
                          style: FigmaTextStyles.h3,
                        ),
                        SizedBox(
                          width: deviceSize.width * 0.03,
                          height: deviceSize.width * 0.03,
                        ),
                        Text(
                          "AI pair learner that navigate the path to  developer mastery. Track progress and tailor your learning adventure.",
                          style: FigmaTextStyles.p.copyWith(
                            color: FigmaColors.sUNRISETextGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )),

              /* Lower half */
              ChangeNotifierProvider<SignInProvider>(
                create: (context) => SignInProvider(),
                child: const MainAuthScreen(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainAuthScreen extends StatefulWidget {
  const MainAuthScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainAuthScreen();
}

class AuthScreenOption1 extends StatefulWidget {
  const AuthScreenOption1({super.key});

  @override
  State<StatefulWidget> createState() => _AuthScreenOption1();
}

class AuthScreenOption2 extends StatefulWidget {
  const AuthScreenOption2({super.key});

  @override
  State<StatefulWidget> createState() => _AuthScreenOption2();
}

class _AuthScreenOption1 extends State<AuthScreenOption1> {
  @override
  void dispose() {
    super.dispose();
    emailReader.dispose();
  }

  final emailReader = TextEditingController();

  void onContinueClicked() {
    Provider.of<SignInProvider>(context, listen: false).changeAuthScreen();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;

    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Container(
      height: safeHeight * 0.55,
      width: deviceSize.width,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(deviceSize.width * 0.06),
      child: ChangeNotifierProvider<Auth>(
        create: (context) => Auth(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Get access with",
              style: FigmaTextStyles.h4,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Provider.of<Auth>(context, listen: false)
                          .signInWithGoogle(context);
                    },
                    icon: SizedBox(
                      width: deviceSize.width * 0.075,
                      height: deviceSize.width * 0.075,
                      child: const Image(
                        image: AssetImage('assets/img/Google-logo.png'),
                      ),
                    ),
                    label: Text(
                      "Google",
                      style: FigmaTextStyles.mButton,
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(deviceSize.width * 0.4, safeHeight * 0.08),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Expanded(child: Divider()),
                SizedBox(
                  width: deviceSize.width * 0.05,
                ),
                Text(
                  "Or",
                  style: FigmaTextStyles.b,
                ),
                SizedBox(
                  width: deviceSize.width * 0.05,
                ),
                const Expanded(child: Divider()),
              ],
            ),
            TextFormField(
              style: FigmaTextStyles.b.copyWith(
                color: FigmaColors.sUNRISECharcoal,
              ),
              controller: emailReader,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Email',
                labelText: 'Email',
                hintStyle: FigmaTextStyles.b,
                labelStyle: FigmaTextStyles.b,
                errorStyle: FigmaTextStyles.mP.copyWith(
                  color: FigmaColors.sUNRISEErrorRed,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<SignInProvider>(context, listen: false)
                    .receiveEmail(emailReader.text);
                onContinueClicked();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                minimumSize: Size(
                    deviceSize.width * 0.95, safeHeight * 0.06), //////// HERE
              ),
              child: Text(
                "Continue",
                style: FigmaTextStyles.mButton.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthScreenOption2 extends State<AuthScreenOption2>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  final emailReader = TextEditingController();
  final passwordReader = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailReader.dispose();
    passwordReader.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    offset = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller);

    emailReader.text =
        Provider.of<SignInProvider>(context, listen: false).email;

    switch (controller.status) {
      case AnimationStatus.completed:
        controller.reverse();
        break;
      case AnimationStatus.dismissed:
        controller.forward();
        break;
      default:
        controller.reverse();
    }
  }

  void returnResponse(status, context) {
    String title = "";
    String message = "";
    late ContentType type;

    switch (status) {
      case Status.SUCESS:
        title = "Welcome to CoDev!";
        message = "We've been waiting for you!";
        type = ContentType.success;
        break;
      default:
        title = "We can't detect you.";
        message = "Peep Po Peep Peep! Nicki.. is that you? ";
        type = ContentType.failure;
        break;
    }

    final materialBanner = MaterialBanner(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: true,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;

    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return SlideTransition(
      position: offset,
      child: Container(
        height: safeHeight * 0.55,
        width: deviceSize.width,
        decoration: BoxDecoration(
          borderRadius: radius,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(deviceSize.width * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Get access with",
              style: FigmaTextStyles.h4,
            ),
            TextFormField(
              style: FigmaTextStyles.b.copyWith(
                color: FigmaColors.sUNRISECharcoal,
              ),
              controller: emailReader,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Email',
                labelText: 'Email',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                hintStyle: FigmaTextStyles.b,
                labelStyle: FigmaTextStyles.b,
                errorStyle: FigmaTextStyles.mP.copyWith(
                  color: FigmaColors.sUNRISEErrorRed,
                ),
              ),
            ),
            TextFormField(
              style: FigmaTextStyles.b.copyWith(
                color: FigmaColors.sUNRISECharcoal,
              ),
              controller: passwordReader,
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Password',
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                hintStyle: FigmaTextStyles.b,
                labelStyle: FigmaTextStyles.b,
                errorStyle: FigmaTextStyles.mP.copyWith(
                  color: FigmaColors.sUNRISEErrorRed,
                ),
              ),
            ),
            ChangeNotifierProvider<Auth>(
              create: (context) => Auth(),
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<SignInProvider>(context, listen: false) .receivePassword(passwordReader.text);
                  Provider.of<Auth>(context, listen: false) .login(emailReader.text, passwordReader.text, context)
                  .then((value) {
                    returnResponse(Status.SUCESS, context);
                    Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
                  })
                  .onError((error, stackTrace) {
                    returnResponse(Status.FAIL, context);
                    Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minimumSize: Size(
                      deviceSize.width * 0.95, safeHeight * 0.06), //////// HERE
                ),
                child: Text(
                  "Log In",
                  style: FigmaTextStyles.mButton.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainAuthScreen extends State<MainAuthScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;

    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Consumer<SignInProvider>(
      builder: (context, system, child) => (system.getStatus() == 0
          ? const AuthScreenOption1()
          : const AuthScreenOption2()),
    );
  }
}

/*
class AuthCard extends StatefulWidget {
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
  AnimationController? _controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;
  var _autoValidate = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );

    super.initState();
  }

  @override
  void dispose() async {
    print('dispose');
    _controller!.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
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
          _authData['email']!,
          _authData['password']!,
          context,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email']!,
          _authData['password']!,
          context,
        );
      }
    } on HttpException catch (error) {
      //await player.resume();
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Theme.of(context).colorScheme.background,
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 365 : 300,
        //height: _heightAnimation!.value.height,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 355 : 290,
        ),
        width: deviceSize.width * 0.8,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    fillColor: Theme.of(context).colorScheme.background,
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                  onTapOutside: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Theme.of(context).colorScheme.background,
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                  onTapOutside: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  obscureText: true,
                  controller: _passwordController,
                  textInputAction: _authMode == AuthMode.Login
                      ? TextInputAction.done
                      : TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 70 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 130 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.done,
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                        onTapOutside: (value) {
                          FocusScope.of(context).unfocus();
                        },
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
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
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'Login' : 'Sign up'),
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    ),
                  ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'Sign up' : 'Log in'} Instead'),
                  onPressed: _switchAuthMode,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
  }
}
*/