import 'package:codev/screens/main_screen.dart';
import 'package:codev/screens/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';

import './firebase_options.dart';
import './screens/agenda_screen.dart';
import './screens/notification_screen.dart';
import './screens/profile_screen.dart';
import './screens/tabs_screen.dart';
import './screens/tasks_screen.dart';
import 'providers/auth.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await fa.FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
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
          home: auth.isAuth
              ? TabsScreen()
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
          },
        ),
      ),
    );
  }
}
