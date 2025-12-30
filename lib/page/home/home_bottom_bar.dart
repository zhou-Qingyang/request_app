import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/route_state.dart';

class HomeBottomBar extends StatefulWidget {
  const HomeBottomBar({super.key});

  @override
  State<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar>
    with SingleTickerProviderStateMixin {
  final titles = ["消息", "通信录", "发现", "我的"];
  final List<IconData> icons = [
    CupertinoIcons.chat_bubble,
    CupertinoIcons.person_2,
    CupertinoIcons.timer,
    CupertinoIcons.person,
  ];
  final List<IconData> activeIcons = [
    CupertinoIcons.chat_bubble_fill,
    CupertinoIcons.person_2_fill,
    CupertinoIcons.timer_fill,
    CupertinoIcons.person_fill,
  ];

  Widget _getBarIcon(int index, bool isActive) {
    return SizedBox(
      width: 24.h,
      height: 24.h,
      child: Icon(
        isActive ? activeIcons[index] : icons[index],
        size: 24.sp,
        color: isActive ? Colors.blue : Colors.black,
      ),
    );
  }

  Widget _getBarText(int index, bool isActive) {
    return Text(
      titles[index],
      style: TextStyle(
        fontSize: 14.sp,
        color: isActive ? Colors.blue : Colors.black,
        height: 1.2, // 控制行高
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis, // 溢出显示省略号
    );
  }

  @override
  Widget build(BuildContext context) {
    // final customColors = Theme.of(context).extension<CustomColors>()!;
    final bottomHeight = MediaQuery.of(context).padding.bottom;
    final currentIndex = context.select((RouterState r) => r.currentIndex);
    return Container(
      height: 60.h + bottomHeight,
      padding: EdgeInsets.only(bottom: bottomHeight),
      decoration: BoxDecoration(
        // color: customColors.bottomNavigationBarThemeBackground!,
      ),
      child: BottomBar(
        currentIndex: currentIndex,
        unFocusColor: const Color(0xFF9E9E9E),  // 灰色（未选中）
        focusColor:  const Color(0xFF2196F3),    // 蓝色（选中）
        onTap: (index) {
          context.read<RouterState>().changeIndex(index);
        },
        items: List<BottomBarItem>.generate(
          4,
              (index) => BottomBarItem(
            icon: _getBarIcon(index, false),
            activeIcon: _getBarIcon(index, true),
            title: _getBarText(index, false),
            activeTitle: _getBarText(index, true),
          ),
        ),
      ),
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

    return Expanded(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => widget.onTap(i),
          splashColor: Colors.transparent, // 移除点击效果
          highlightColor: Colors.transparent, // 移除点击效果
          child: Container(
            constraints: BoxConstraints(
              minHeight: 60.h,
            ),
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

  BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.activeTitle,
  });
}