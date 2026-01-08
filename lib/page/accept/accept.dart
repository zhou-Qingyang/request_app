import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/accept/accept_edit.dart';
import 'package:quest_app/page/accept/progress.dart';
import 'package:quest_app/provider/accept_state.dart';
import '../../helper/style.dart';
import '../widgets/svg_button.dart';

class AcceptPage extends StatefulWidget {
  const AcceptPage({super.key});

  @override
  State<AcceptPage> createState() => _AcceptPageState();
}

class AcceptInfo {
  final int id;
  final String title;
  final String money;
  final String score;

  AcceptInfo(this.id, this.title, this.money, this.score);

  AcceptInfo copyWith({int? id, String? title, String? money, String? score}) {
    return AcceptInfo(
      id ?? this.id,
      title ?? this.title,
      money ?? this.money,
      score ?? this.score,
    );
  }
}

class _AcceptPageState extends State<AcceptPage> {
  // final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double _progress = 0.3;

  void _updateProgress() {
    setState(() {
      _progress = _progress >= 1.0 ? 0.0 : _progress + 0.1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _contentHeight = 44.h;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final double paddingHeight = _contentHeight + statusBarHeight;
    final List<AcceptInfo> accepts = context.select(
      (AcceptState r) => r.accepts,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(false),
      child: Scaffold(
        backgroundColor: Styles.mainBackground,
        extendBodyBehindAppBar: true,
        appBar: null,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
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
                              Center(
                                child: Text(
                                  "抢单",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
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
                                    color: Color(0xFFedf2fe),
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
                                            MaterialPageRoute(builder: (context) => AcceptEditPage()),
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
                        ), // appbar
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFf6f9fe),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/icons/18.png",width: 16,height: 16,),
                                Text(
                                  "进阶课程",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3770eb),
                                  ),
                                ),
                                _buildDivider(),
                                Text(
                                  "收入提高第一步  答题公式要记牢",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Styles.mainFontColor,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    splashFactory: NoSplash.splashFactory,
                                    backgroundColor: Colors.transparent, // 透明背景
                                    shadowColor: Colors.transparent,     // 无阴影
                                    shape: RoundedRectangleBorder(       // 无圆角/边框
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  child: Text(
                                    "更多",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Color(0xFF3770eb),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DotProgressBar(
                                      progress: 0,
                                      height: 10,
                                      dotSize: 8,
                                    ),
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.white
                                    //   ),
                                    //   child: Text("20提"),
                                    // )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "40",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Styles.mainFontColor,
                                              height: 1.4, // 行高适配
                                            ),
                                          ),
                                          TextSpan(
                                            text: "题",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Styles.mainFontColor,
                                              height: 1.4, // 行高适配
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "抢单上线",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Styles.mainFontColor,
                                              height: 1.4, // 行高适配
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.help_outline,
                                              color:
                                                  Styles.chevronRightIconColor,
                                              size: 14.sp,
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
                        ), // 进度条
                      ],
                    ),
                  ),
                ],
              ),
              Transform(
                transform: Matrix4.translationValues(0, -40, 0),
                origin: Offset(0, 0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(accepts.length, (index) {
                        return Column(
                          children: [
                            _buildAcceptItem(accepts[index]),
                            const SizedBox(height: 6),
                            if (index != accepts.length - 1)
                              Divider(
                                color: Colors.grey[200],
                                thickness: 1.w,
                                height: 1.h,
                              ),
                            const SizedBox(height: 6),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
             const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAcceptItem(AcceptInfo accept) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          accept.title,
          maxLines: 3,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Styles.mainFontColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "¥ ",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: accept.money,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.w, right: 2.w),
                      child: Icon(Icons.add, size: 12.sp, color: Colors.red),
                    ),
                  ),
                  TextSpan(
                    text: "${accept.score}问贝",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Image.asset("assets/icons/20.png",width: 16,height: 16,),
                SizedBox(width: 4.w),
                Text(
                  "去抢单",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Styles.themeStartColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
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
      icon: Icon(icon, color: Colors.black),
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

  Widget _buildClass() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "课程上新",
                    style: TextStyle(
                      color: Styles.mainFontColor,
                      fontSize: 16.sp,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        "全部课程",
                        style: TextStyle(
                          color: Styles.chevronRightIconColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: Styles.chevronRightIconColor,
                        size: 14.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _buildClassItem(
                  "https://picsum.photos/1920/1080",
                  "如何获得 答主标签,得到平台的认可？",
                ),
                _buildClassDivider(),
                _buildClassItem(
                  "https://picsum.photos/1920/1080",
                  "如何获得 答主标签,得到平台的认可？",
                ),
                _buildClassDivider(),
                _buildClassItem(
                  "https://picsum.photos/1920/1080",
                  "如何获得 答主标签,得到平台的认可？",
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassItem(String imgUrl, String title) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            imgUrl,
            width: 120.w,
            height: 80.w,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, color: Styles.mainFontColor),
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "19.0万阅读",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]!),
                  ),
                  TextButton(
                    onPressed: () {
                      print('按钮被点击');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF3f6ff4), // 文字颜色
                      side: BorderSide(
                        color: Color(0xFF3f6ff4).withOpacity(0.1), // 边框颜色
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r), // 圆角
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                    ),
                    child: Text(
                      '去学习',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 10.w),
      decoration: BoxDecoration(color: Styles.mainFontColor.withOpacity(0.1)),
    );
  }
}
