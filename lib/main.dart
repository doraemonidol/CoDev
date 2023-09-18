import 'dart:io';

import 'package:codev/providers/field.dart';
import 'package:codev/providers/sign_in_info.dart';
import 'package:codev/providers/tasks.dart';
import 'package:codev/providers/user.dart';
import 'package:codev/screens/detailed_task_screen.dart';
import 'package:codev/screens/endquiz_screen.dart';
import 'package:codev/screens/main_screen.dart';
import 'package:codev/screens/new_lesson_screen.dart';
import 'package:codev/screens/on_boarding_screen.dart';
import 'package:codev/screens/quiz_screen.dart';
import 'package:codev/screens/signup_screen.dart';
import 'package:codev/screens/test_fs.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';

import './firebase_options.dart';
import './screens/agenda_screen.dart';
import './screens/notification_screen.dart';
import './screens/profile_screen.dart';
import './screens/tabs_screen.dart';
import './screens/tasks_screen.dart';
import 'helpers/notification_service.dart';
import 'providers/auth.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

Future<void> main() async {
  // TaskList taskList = TaskList(date: DateTime.now(), tasks: [
  //   Task(
  //     field: 'Backend',
  //     stage: 'Stage 1',
  //     course: 'Course 1',
  //     startTime: DateTime.now().add(Duration(minutes: 16)),
  //     endTime:
  //         DateTime.now().add(Duration(minutes: 16)).add(Duration(hours: 2)),
  //     state: TaskState.todo.index,
  //     color: Colors.red,
  //     icon: CupertinoIcons.arrow_down_right_arrow_up_left,
  //   ),
  // ]);

  // String taskString = taskList.tasks[0].toString();
  // print(taskString);
  // Task task = taskFromString(taskString);
  // print(task.field);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = TabsScreen.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
    initialRoute = TabsScreen.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  //await fa.FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(MyApp(
    initialRoute,
    notificationAppLaunchDetails,
    selectedNotificationPayload,
  ));
}

class MyApp extends StatefulWidget {
  static const routeName = '/';
  final String initialRoute;
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  final String? selectedNotificationPayload;

  const MyApp(
    this.initialRoute,
    this.notificationAppLaunchDetails,
    this.selectedNotificationPayload,
  );

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => DetailedTaskScreen(
                        payload: null,),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => DetailedTaskScreen(payload: payload),
      ));
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkPendingNotificationRequests();
    // _getActiveNotifications();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => User(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SignUpProvider(),
        ),
        ChangeNotifierProvider<SignInProvider>(
          create: (context) => SignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TaskList(
            date: DateTime.now(),
            tasks: [],
          ),
        ),
        // ChangeNotifierProxyProvider<Auth, Products>(
        //   update: (ctx, auth, previousProduct) => Products(
        //     auth.token,
        //     auth.userId,
        //     previousProduct == null ? [] : previousProduct.items,
        //   ),
        //   create: (ctx) => Products('', '', []),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'CoDev',
          theme: FlexThemeData.light(
            scheme: FlexScheme.bahamaBlue,
            usedColors: 2,
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
            blendLevel: 4,
            appBarStyle: FlexAppBarStyle.background,
            bottomAppBarElevation: 1.0,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
              blendTextTheme: true,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              thickBorderWidth: 2.0,
              elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
              elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
              inputDecoratorSchemeColor: SchemeColor.primary,
              inputDecoratorBackgroundAlpha: 12,
              inputDecoratorRadius: 8.0,
              inputDecoratorUnfocusedHasBorder: false,
              inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
              appBarScrolledUnderElevation: 8.0,
              drawerElevation: 1.0,
              drawerWidth: 290.0,
              bottomNavigationBarSelectedLabelSchemeColor:
                  SchemeColor.secondary,
              bottomNavigationBarMutedUnselectedLabel: false,
              bottomNavigationBarSelectedIconSchemeColor: SchemeColor.secondary,
              bottomNavigationBarMutedUnselectedIcon: false,
              navigationBarSelectedLabelSchemeColor:
                  SchemeColor.onSecondaryContainer,
              navigationBarSelectedIconSchemeColor:
                  SchemeColor.onSecondaryContainer,
              navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
              navigationBarIndicatorOpacity: 1.00,
              navigationBarElevation: 1.0,
              navigationBarHeight: 72.0,
              navigationRailSelectedLabelSchemeColor:
                  SchemeColor.onSecondaryContainer,
              navigationRailSelectedIconSchemeColor:
                  SchemeColor.onSecondaryContainer,
              navigationRailIndicatorSchemeColor:
                  SchemeColor.secondaryContainer,
              navigationRailIndicatorOpacity: 1.00,
            ),
            useMaterial3ErrorColors: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            // To use the Playground font, add GoogleFonts package and uncomment
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          darkTheme: FlexThemeData.dark(
            colors: FlexColor.schemes[FlexScheme.bahamaBlue]!.light.defaultError
                .toDark(40, false),
            usedColors: 2,
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
            blendLevel: 10,
            appBarStyle: FlexAppBarStyle.background,
            bottomAppBarElevation: 2.0,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 20,
              blendTextTheme: true,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              thickBorderWidth: 2.0,
              elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
              elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
              inputDecoratorSchemeColor: SchemeColor.primary,
              inputDecoratorBackgroundAlpha: 48,
              inputDecoratorRadius: 8.0,
              inputDecoratorUnfocusedHasBorder: false,
              inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
              drawerElevation: 1.0,
              drawerWidth: 290.0,
              bottomNavigationBarSelectedLabelSchemeColor:
                  SchemeColor.secondary,
              bottomNavigationBarMutedUnselectedLabel: false,
              bottomNavigationBarSelectedIconSchemeColor: SchemeColor.secondary,
              bottomNavigationBarMutedUnselectedIcon: false,
              navigationBarSelectedLabelSchemeColor:
                  SchemeColor.onSecondaryContainer,
              navigationBarSelectedIconSchemeColor:
                  SchemeColor.onSecondaryContainer,
              navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
              navigationBarIndicatorOpacity: 1.00,
              navigationBarElevation: 1.0,
              navigationBarHeight: 72.0,
              navigationRailSelectedLabelSchemeColor:
                  SchemeColor.onSecondaryContainer,
              navigationRailSelectedIconSchemeColor:
                  SchemeColor.onSecondaryContainer,
              navigationRailIndicatorSchemeColor:
                  SchemeColor.secondaryContainer,
              navigationRailIndicatorOpacity: 1.00,
            ),
            useMaterial3ErrorColors: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            // To use the Playground font, add GoogleFonts package and uncomment
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
          themeMode: ThemeMode.system,
          // home: MyFirstScreen(
          //   showNotification: _checkPendingNotificationRequests,
          // ),
          // initialRoute: !auth.isAuth ? null : widget.initialRoute,
          home: auth.isAuth // auth.isAuth
              ? (auth.isFirstTime ? MainScreen() : TabsScreen())
              : FutureBuilder(
                  future: auth.tryAutoLogin(context),
                  builder: (cxt, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            AgendaScreen.routeName: (ctx) => AgendaScreen(),
            NotificationScreen.routeName: (ctx) => NotificationScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            TasksScreen.routeName: (ctx) => TasksScreen(),
            OnBoardingScreen.routeName: (ctx) => OnBoardingScreen(),
            MainScreen.routeName: (ctx) => MainScreen(),
            TabsScreen.routeName: (ctx) => TabsScreen(),
            DetailedTaskScreen.routeName: (ctx) => DetailedTaskScreen(
                  payload: null,
                ),
            QuizScreen.routeName: (ctx) => QScreen(),
            EndQuiz.routeName: (ctx) => EndQuiz(),
            NewLessonScreen.routeName: (ctx) => NewLessonScreen(),
          },
        ),
      ),
    );
  }
}

// class MyFirstScreen extends StatelessWidget {
//   Function showNotification;

//   MyFirstScreen({Key? key, required this.showNotification});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notification'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await showNotification();
//           },
//           child: Text('Show Notification'),
//         ),
//       ),
//     );
//   }
// }

// class MySecondScreen extends StatelessWidget {
//   final String payload;

//   MySecondScreen(this.payload);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notification'),
//       ),
//       body: Center(
//         child: Text(payload),
//       ),
//     );
//   }
// }
