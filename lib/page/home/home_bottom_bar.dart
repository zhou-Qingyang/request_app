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
  final titles = ["咨询广场", "咨询抢单", "", "答主中心", "个人中心"];
  final List<String> icons = [
    "assets/bar/bar1.png",
    "assets/bar/bar2.png",
    "assets/bar/bar-center.png",
    "assets/bar/bar3.png",
    "assets/bar/bar4.png",
  ];

  final List<String> activeIcons = [
    "assets/bar/bar1.png",
    "assets/bar/bar2-1.png",
    "assets/bar/bar-center.png",
    "assets/bar/bar3-1.png",
    "assets/bar/bar4.png",
  ];

  Widget _getBarIcon(int index, bool isActive) {
    if (index == 2) {
      return SizedBox.shrink();
    }
    return SizedBox(
      width: 24.h,
      height: 24.h,
      child: Image.asset(
        isActive ? activeIcons[index] : icons[index],
        width: 24.w,
        height: 24.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _getBarText(int index, bool isActive) {
    if (index == 2) {
      return SizedBox.shrink();
    }
    if (index == 1) {
      if (isActive) {
        titles[index] = "刷新";
      } else {
        titles[index] = "咨询抢单";
      }
    }

    return Text(
      titles[index],
      style: TextStyle(
        fontSize: 14.sp,
        color: isActive ? Styles.bottomBarSelected : Styles.bottomBarUnSelected,
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
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, -2),
                blurRadius: 8,
              ),
            ],
          ),
          child: BottomBar(
            currentIndex: currentIndex,
            unFocusColor: Styles.bottomBarUnSelected,
            focusColor: Styles.bottomBarSelected,
            onTap: (index) {
              context.read<RouterState>().changeIndex(index);
            },
            items: List<BottomBarItem>.generate(
              5,
              (index) => BottomBarItem(
                icon: _getBarIcon(index, false),
                activeIcon: _getBarIcon(index, true),
                title: _getBarText(index, false),
                activeTitle: _getBarText(index, true),
                isCenter: index == 2, // 标记中间按钮
              ),
            ),
          ),
        ),
        // 中间凸起的圆形按钮
        Positioned(
          bottom: bottomHeight + 5.h,
          child: GestureDetector(
            onTap: () {
              context.read<RouterState>().changeIndex(2);
            },
            child: SizedBox(
              width: 56.w,
              height: 56.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  icons[2],
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.cover,
                ),
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
      return Expanded(child: SizedBox(height: 60.h));
    }

    return Expanded(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => widget.onTap(i),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(minHeight: 60.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                selected ? item.activeIcon : item.icon,
                SizedBox(height: 2.h),
                selected ? item.activeTitle : item.title,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
