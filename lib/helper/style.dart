import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SystemUiOverlayStyle getSystemUiOverlayStyle(bool isDark) {
  if (isDark) {
    // 深色模式
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,                    // 状态栏背景透明
      statusBarIconBrightness: Brightness. light,            // 状态栏图标亮色
      statusBarBrightness: Brightness.dark,                 // iOS 状态栏样式
      systemNavigationBarColor: Color(0xFF000000),          // 底部导航栏黑色
      systemNavigationBarIconBrightness: Brightness.light,  // 导航栏图标亮色
      systemNavigationBarDividerColor: Colors.transparent,  // 导航栏分割线透明
    );
  } else {
    // 浅色模式
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,                    // 状态栏背景透明
      statusBarIconBrightness:  Brightness.dark,             // 状态栏图标暗色
      statusBarBrightness: Brightness.light,                // iOS 状态栏样式
      systemNavigationBarColor: Colors.white,               // 底部导航栏白色
      systemNavigationBarIconBrightness: Brightness.dark,   // 导航栏图标暗色
      systemNavigationBarDividerColor: Colors. transparent,  // 导航栏分割线透明
    );
  }
}