import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quest_app/page/widgets/svg_button.dart';
import '../../helper/style.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _contentHeight = 44.h;
  final Widget title;

  MainAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: statusBarHeight + _contentHeight,
      decoration: BoxDecoration(
        color: Styles.themeStartColor,
        border: Border(bottom: BorderSide.none),
      ),
      padding: EdgeInsets.only(top: statusBarHeight, left: 10.w, right: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _contentHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(child: title),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    height: _contentHeight * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // 淡色背景
                      borderRadius: BorderRadius.circular(20), // 可选：添加圆角
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgIconButton(
                          assetName: 'assets/svg/more.svg',
                          onPressed: () {},
                          color: Colors.white,
                          iconSize: 14.sp,
                        ),
                        _buildDivider(),
                        SvgIconButton(
                          assetName: 'assets/svg/close.svg',
                          onPressed: () {},
                          color: Colors.white,
                          iconSize: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: _contentHeight * 0.5,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
    );
  }

  Widget _createButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      iconSize: 16.sp,
      alignment: Alignment.center,
      constraints: BoxConstraints(
        minHeight: _contentHeight,
        maxHeight: _contentHeight,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(50 + _contentHeight);
  }
}
