import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/home/home.dart';
import 'package:quest_app/provider/route_state.dart';
import 'package:quest_app/router/routes.dart';

import 'helper/custom_theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(375.0, 812.0),
      builder:
          (context, child) => OKToast(
        child: MultiProvider(
          // providers: [
          //   ChangeNotifierProvider<AppThemeState>(
          //     create: (_) => AppThemeState('light'),
          //   ),

          //   ChangeNotifierProvider<MessageState>(
          //     create: (_) => MessageState(),
          //   ),
          //   ChangeNotifierProvider<DiscoverState>(
          //     create: (_) => DiscoverState(),
          //   ),
          //   ChangeNotifierProvider<ContactState>(
          //     create: (_) => ContactState(),
          //   ),
          // ],
          providers: [
              ChangeNotifierProvider<RouterState>(
                create: (_) => RouterState(),
              ),
          ],
          child: MaterialApp(
            title: 'Gim-Mobile',
            themeMode: ThemeMode.light,
            theme: createLightThemeData(),
            darkTheme: createDarkThemeData(),
            routes: {
              RoutesPath.HOME_PAGE: (context) => HomePage(),
              // RoutesPath.LOGIN_PAGE: (context) => LoginPage(),
              // RoutesPath.REGISTER_PAGE: (context) => RegisterPage(),
              // RoutesPath.SEARCH_PAGE: (context) => SearchContact(),
            },
            initialRoute: RoutesPath.HOME_PAGE,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

ThemeData createLightThemeData() {
  return ThemeData.light(useMaterial3: true).copyWith(
    extensions: [CustomColors.light],
    textTheme: ThemeData(fontFamily: 'AlibabaPuHuiTi').textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    dividerColor: Colors.transparent,
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        highlightColor: Colors.transparent,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(menuPadding: EdgeInsets.zero),
    listTileTheme: ListTileThemeData(contentPadding: EdgeInsets.zero),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey, width: 1),
      ),
      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp, height: 1.2),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: Colors.blue,
      cursorColor: Colors.blue,
      selectionColor: Colors.blue.withOpacity(0.5),
    ),
  );
  //(255, 4, 190, 2) 微信绿
}

ThemeData createDarkThemeData() {
  return ThemeData.dark(useMaterial3: true).copyWith(
    extensions: [CustomColors.dark],
    textTheme: ThemeData(fontFamily: 'AlibabaPuHuiTi').primaryTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.zero,
      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp, height: 1.2),
    ),
    popupMenuTheme: PopupMenuThemeData(menuPadding: EdgeInsets.zero),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    ),
    dividerColor: Colors.transparent,
  );
}
