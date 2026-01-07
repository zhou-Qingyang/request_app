import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quest_app/page/analysis/payment_edit.dart';
import 'package:quest_app/page/order/order_edit.dart';
import '../../helper/style.dart';
import '../widgets/svg_button.dart';

class PaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _contentHeight = 44.h;
  final Widget title;

  PaymentAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: statusBarHeight + _contentHeight,
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
                  child: Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    height: _contentHeight * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20), // 可选：添加圆角
                      border: Border.all(width: 1, color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgIconButton(
                          assetName: 'assets/svg/more.svg',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentEditPage(),
                              ),
                            );
                          },
                          color: Colors.black87,
                          iconSize: 14.sp,
                        ),
                        _buildDivider(),
                        SvgIconButton(
                          assetName: 'assets/svg/close.svg',
                          onPressed: () {},
                          color: Colors.black87,
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
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
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
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(50 + _contentHeight);
  }
}
