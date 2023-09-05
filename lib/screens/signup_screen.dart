import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codev/providers/sign_in_info.dart';
import 'package:codev/providers/user.dart';
import 'package:codev/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../helpers/style.dart';

enum Status { SUCESS, EMAIL_EXISTS, INVALID_EMAIL, ELSE }

class SignUpScreen extends StatefulWidget {

  static const routeName = '/signup';

  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final emailReader = TextEditingController();

  final passwordReader = TextEditingController();

  Future<void> handleSignUp(context) async {
    await Provider.of<Auth>(context, listen: false).signup(
      emailReader.text,
      passwordReader.text,
      context,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailReader.dispose();
    passwordReader.dispose();
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
      case Status.EMAIL_EXISTS:
        title = "You forgot, mate?";
        message = "Look like you've already signed up! Try sigining in.";
        type = ContentType.failure;
        break;
      case Status.INVALID_EMAIL:
        title = "Alien detected!";
        message = "Your email.. doesn't look like an email?";
        type = ContentType.warning;
        break;
      default:
        title = "Something happened!";
        message = "but I don't know what it is. Try again!";
        type = ContentType.help;
        break;
    }

    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: type,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '👋',
                      style: FigmaTextStyles.h1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Getting Started",
                          style: FigmaTextStyles.h3.copyWith(
                            color: FigmaColors.sUNRISECharcoal,
                          ),
                        ),
                        SizedBox(height: deviceSize.height * 0.005),
                        Text(
                          "Create an account to continue!",
                          style: FigmaTextStyles.p.copyWith(
                            color: FigmaColors.sUNRISETextGrey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: deviceSize.height * 0.05),
                TextFormField(
                  style: FigmaTextStyles.b.copyWith(
                    color: FigmaColors.sUNRISECharcoal,
                  ),
                  controller: emailReader,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                    hintStyle: FigmaTextStyles.b,
                    labelStyle: FigmaTextStyles.b,
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.02),
                TextFormField(
                  style: FigmaTextStyles.b.copyWith(
                    color: FigmaColors.sUNRISECharcoal,
                  ),
                  controller: passwordReader,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    hintStyle: FigmaTextStyles.b,
                    labelStyle: FigmaTextStyles.b,
                    errorStyle: FigmaTextStyles.mP.copyWith(
                      color: FigmaColors.sUNRISEErrorRed,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value?.length)! < 6
                      ? 'Password must be at least 6 characters long'
                      : null,
                ),
                SizedBox(height: deviceSize.height * 0.02),
                TextFormField(
                  style: FigmaTextStyles.b.copyWith(
                    color: FigmaColors.sUNRISECharcoal,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    hintStyle: FigmaTextStyles.b,
                    labelStyle: FigmaTextStyles.b,
                    errorStyle: FigmaTextStyles.mP.copyWith(
                      color: FigmaColors.sUNRISEErrorRed,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value! == passwordReader.text)
                      ? null
                      : "It is not the same.",
                ),
                SizedBox(height: deviceSize.height * 0.05),
                Center(
                  child: SizedBox(
                      width: deviceSize.width * 0.8,
                      height: deviceSize.height * 0.07,
                      child: ChangeNotifierProvider<User>(
                        create: (context) => User(),
                        child: ElevatedButton(
                            onPressed: () {
                              handleSignUp(context)
                              .then((value) {
                                returnResponse(Status.SUCESS, context);
                                Navigator.of(context).pushNamed(QuizScreen.routeName);
                              })
                              .onError((error, stackTrace) {
                                switch (error.toString()) {
                                  case 'HttpException: INVALID_EMAIL':
                                    returnResponse(
                                        Status.INVALID_EMAIL, context);
                                    break;
                                  case 'HttpException: EMAIL_EXISTS':
                                    returnResponse(
                                        Status.EMAIL_EXISTS, context);
                                    break;
                                  default:
                                    returnResponse(Status.ELSE, context);
                                    break;
                                }
                                throw Exception(error);
                              });
                            },
                            child: Text(
                              "Create Account",
                              style: FigmaTextStyles.mButton,
                            )),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
