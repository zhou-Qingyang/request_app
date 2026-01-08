import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/accept/accept_edit.dart';
import 'package:quest_app/page/accept/progress.dart';
import 'package:quest_app/page/withDraw/withDraw_edit.dart';
import 'package:quest_app/provider/accept_state.dart';
import 'package:quest_app/provider/order_state.dart';
import '../../helper/style.dart';
import '../widgets/svg_button.dart';

class WithDrawPage extends StatefulWidget {
  const WithDrawPage({super.key});

  @override
  State<WithDrawPage> createState() => _WithDrawPageState();
}

class _WithDrawPageState extends State<WithDrawPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _contentHeight = 44.h;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final double paddingHeight = _contentHeight + statusBarHeight;
    final List<WithDrawInfo> withDraws = context.select(
      (OrderState r) => r.withDraws,
    );
    final String totalAmount = context.select((OrderState r) => r.formattedTotalAmount);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(false),
      child: Scaffold(
        backgroundColor: Styles.mainBackground,
        extendBodyBehindAppBar: true,
        appBar: null,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFF5540),
                        Color(0xFFFF5540),
                        Color(0xFFff262b),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Column(
                    children: [
                      // 标题头
                      Container(
                        height: paddingHeight,
                        padding: EdgeInsets.only(
                          top: statusBarHeight,
                          left: 10.w,
                          right: 10.w,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: 0,
                              child: Row(
                                children: [
                                  _createButton2(
                                    CupertinoIcons.chevron_left,
                                    () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  Image.asset("assets/icons/16.png",width: 18.sp,height: 18.sp,color: Colors.white,)
                                ],
                              ),
                            ),
                            Center(
                              child: Text(
                                "百度提现中心",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                height: _contentHeight * 0.6,
                                decoration: BoxDecoration(
                                    color:Colors.black87.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20), // 可选：添加圆角
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
                                            builder: (context) =>
                                                WithDrawEditPage(),
                                          ),
                                        );
                                      },
                                      color: Colors.white,
                                      iconSize: 14.sp,
                                    ),
                                    const SizedBox(width: 12,),
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
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi,您好~",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "当前可提现（元）",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                child: SizedBox(
                                  height: 63,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.asset(
                                      "assets/icons/15.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "0.00",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Color(0xFFf12229),
                                    side: BorderSide(
                                      color: Color(
                                        0xFF3f6ff4,
                                      ).withOpacity(0.1), // 边框颜色
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        24.r,
                                      ), // 圆角
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 6.w,
                                    ),
                                  ),
                                  child: Text(
                                    '提现至银行卡',
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "累积获得（元）$totalAmount",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(0xFFff403e),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "提现记录",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: withDraws.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = withDraws[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/14.png",
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "银行卡",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      item.amount,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.date,
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "提现成功",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Divider(
                      height: 1,
                      thickness: 1, // 线的粗细
                      color: Colors.grey[100],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _createButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      iconSize: 16.sp,
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 44.h, maxHeight: 44.h),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 44.h * 0.5,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
    );
  }

  Widget _createButton2(IconData icon, VoidCallback onPressed) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      iconSize: 20.sp,
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 44.h, maxHeight: 44.h),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }
}
