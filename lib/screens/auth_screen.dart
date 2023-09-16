import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codev/providers/sign_in_info.dart';
import 'package:codev/screens/endquiz_screen.dart';
import 'package:codev/screens/main_screen.dart';
import 'package:codev/screens/quiz_screen.dart';
import 'package:codev/screens/tabs_screen.dart';
import 'package:codev/screens/tasks_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/style.dart';
import '../providers/auth.dart';
import '../screens/signup_screen.dart';
import '../providers/music.dart';

enum AuthMode { Signup, Login }

enum Status { SUCESS, FAIL }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    startMusicList();
    final deviceSize = MediaQuery.of(context).size;
    double safeHeight = deviceSize.height - MediaQuery.of(context).padding.top;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);

    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    print("AuthScreen build");
    return Consumer<SignUpProvider>(
      builder: (context, system, child) => (system.getIsSigningUp()
          ? SignUpScreen(
              Provider.of<SignInProvider>(context, listen: false).email)
          : Scaffold(
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
                                  width: deviceSize.width * 0.3,
                                  height: deviceSize.width * 0.3,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding:
                                        EdgeInsets.all(deviceSize.width * 0.05),
                                    child: const Image(
                                        image: AssetImage(
                                            'assets/images/logo.png')),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
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

                      MainAuthScreen(),
                    ],
                  ),
                ),
              ),
            )),
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

                Provider.of<Auth>(context, listen: false)
                    .login(emailReader.text, 'password', context)
                    .then((value) {})
                    .onError((error, stackTrace) {
                  if (error == 'HttpException: EMAIL_NOT_FOUND')
                    Provider.of<SignUpProvider>(context, listen: false)
                        .changeSigningUp();
                  else
                    onContinueClicked();
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

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
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

    _showErrorDialog(title, message);
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
              "Log in with",
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
                  Provider.of<SignInProvider>(context, listen: false)
                      .receivePassword(passwordReader.text);
                  Provider.of<Auth>(context, listen: false)
                      .login(emailReader.text, passwordReader.text, context)
                      .then((value) {
                    Provider.of<SignInProvider>(context, listen: false)
                        .changeAuthScreen();
                  }).onError((error, stackTrace) {
                    returnResponse(Status.FAIL, context);
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
