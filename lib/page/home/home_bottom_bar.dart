import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../helper/style.dart';
import '../../provider/route_state.dart';

class HomeBottomBar extends StatefulWidget {
  const HomeBottomBar({super.key});

  @override
  State<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar>
    with SingleTickerProviderStateMixin {
  final titles = ["消息", "通信录", "", "发现", "我的"]; // 中间留空
  final List<IconData> icons = [
    CupertinoIcons.chat_bubble,
    CupertinoIcons. person_2,
    CupertinoIcons.plus,
    CupertinoIcons.timer,
    CupertinoIcons.person,
  ];
  final List<IconData> activeIcons = [
    CupertinoIcons.chat_bubble_fill,
    CupertinoIcons.person_2_fill,
    CupertinoIcons.plus_circle_fill,
    CupertinoIcons.timer_fill,
    CupertinoIcons.person_fill,
  ];

  Widget _getBarIcon(int index, bool isActive) {
    // 中间按钮特殊处理
    if (index == 2) {
      return SizedBox. shrink();
    }
    return SizedBox(
      width:  24.h,
      height: 24.h,
      child: Icon(
        isActive ? activeIcons[index] :  icons[index],
        size:  24.sp,
        color: isActive ? Styles.bottomBarSelected : Styles.bottomBarUnSelected,
      ),
    );
  }

  Widget _getBarText(int index, bool isActive) {
    // 中间按钮不显示文字
    if (index == 2) {
      return SizedBox.shrink();
    }
    return Text(
      titles[index],
      style: TextStyle(
        fontSize: 14.sp,
        color: isActive ? Styles.bottomBarSelected : Styles. bottomBarUnSelected,
        height: 1.2,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomHeight = MediaQuery.of(context).padding.bottom;
    final currentIndex = context.select((RouterState r) => r.currentIndex);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 60.h + bottomHeight,
          padding: EdgeInsets.only(bottom: bottomHeight),
          decoration: BoxDecoration(
            color: Colors. white,
            boxShadow: [
              BoxShadow(
                color:  Colors.black.withOpacity(0.05),
                offset: Offset(0, -2),
                blurRadius: 8,
              ),
            ],
          ),
          child: BottomBar(
            currentIndex:  currentIndex,
            unFocusColor: Styles.bottomBarUnSelected,
            focusColor: Styles.bottomBarSelected,
            onTap: (index) {
              context.read<RouterState>().changeIndex(index);
            },
            items:  List<BottomBarItem>. generate(
              5, // 改为5个
                  (index) => BottomBarItem(
                icon: _getBarIcon(index, false),
                activeIcon: _getBarIcon(index, true),
                title: _getBarText(index, false),
                activeTitle:  _getBarText(index, true),
                isCenter: index == 2, // 标记中间按钮
              ),
            ),
          ),
        ),
        // 中间凸起的圆形按钮
        Positioned(
          bottom: bottomHeight + 5.h, // 超出底部导航栏
          child: GestureDetector(
            onTap: () {
              context.read<RouterState>().changeIndex(2);
            },
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3457ce),
                    Color(0xFF5B7FE8),
                  ],
                  begin: Alignment.topLeft,
                  end:  Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3457ce).withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius:  12,
                  ),
                ],
              ),
              child: Icon(
                currentIndex == 2
                    ? CupertinoIcons. plus_circle_fill
                    : CupertinoIcons.plus,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomBar extends StatefulWidget {
  final List<BottomBarItem> items;
  final int currentIndex;
  final Color focusColor;
  final Color unFocusColor;
  final ValueChanged<int> onTap;

  const BottomBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    required this.focusColor,
    required this.unFocusColor,
    required this.onTap,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  Widget _createItem(int i) {
    final BottomBarItem item = widget.items[i];
    final bool selected = i == widget.currentIndex;
    // 中间按钮占位符（透明不可见）
    if (item.isCenter) {
      return Expanded(
        child: SizedBox(
          height: 60.h,
        ),
      );
    }

    return Expanded(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => widget.onTap(i),
          splashColor: Colors.transparent,
          highlightColor: Colors. transparent,
          child: Container(
            constraints: BoxConstraints(
              minHeight: 60.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                selected ? item. activeIcon : item.icon,
                SizedBox(height: 2.h),
                selected ?  item.activeTitle : item.title,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            minHeight: 60.h,
            maxHeight: 60.h + MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.items.length, _createItem),
          ),
        );
      },
    );
  }
}

class BottomBarItem {
  final Widget icon;
  final Widget activeIcon;
  final Widget title;
  final Widget activeTitle;
  final bool isCenter;

  BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.activeTitle,
    this.isCenter = false,
  });
}