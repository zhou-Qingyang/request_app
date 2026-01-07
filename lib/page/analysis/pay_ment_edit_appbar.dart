import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quest_app/page/order/order_edit.dart';
import '../../helper/style.dart';

class PaymentEditBar extends StatelessWidget implements PreferredSizeWidget {
  final double _contentHeight = 44.h;
  final Widget title;
  final VoidCallback onAdd;

  PaymentEditBar({Key? key, required this.title,required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: statusBarHeight + _contentHeight,
      decoration: BoxDecoration(
        color: Styles.mainBackground,
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
                Positioned(
                  left: 0,
                  child: _createButton2(CupertinoIcons.chevron_left, () {
                    Navigator.pop(context);
                  }),
                ),
                Center(child: title),
                Positioned(
                  right: 0,
                  child: _createButton2(CupertinoIcons.plus, () {
                    onAdd();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createButton2(IconData icon, VoidCallback onPressed) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      iconSize: 20.sp,
      alignment: Alignment.center,
      constraints: BoxConstraints(
        minHeight: _contentHeight,
        maxHeight: _contentHeight,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }


  @override
  Size get preferredSize {
    return Size.fromHeight(50 + _contentHeight);
  }
}
