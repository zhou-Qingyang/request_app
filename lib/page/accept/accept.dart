import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quest_app/page/accept/progress.dart';
import 'package:quest_app/page/order/order_appbar.dart';
import 'package:quest_app/page/widgets/main_appbar.dart';
import '../../helper/style.dart';

class AcceptPage extends StatefulWidget {
  const AcceptPage({super.key});

  @override
  State<AcceptPage> createState() => _AcceptPageState();
}

class OrderInfo {
  final String fromName;
  final String avatarUrl;
  final String status;
  final String question;
  final String date;
  final String type;

  OrderInfo(
    this.fromName,
    this.status,
    this.question,
    this.date,
    this.type,
    this.avatarUrl,
  );
}

class _AcceptPageState extends State<AcceptPage> {
  final PageController _pageController = PageController();
  late PageController _bannerPageController = PageController();
  int _currentPage = 0;
  final List<String> buttonTitles = ['全部', '已预约', '待应答', '进行中', '已完成', '退款'];
  int selectedIndex = 0;

  // 模拟数据源（20条）
  late List<OrderInfo> _allOrderData;

  // 显示的列表数据
  List<OrderInfo> _displayOrderData = [];

  // 每次加载数量
  static const int _loadCount = 5;

  // 滚动控制器
  final ScrollController _scrollController = ScrollController();

  // 是否正在加载
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _allOrderData = _generateFakeOrderData(20);
    _loadMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading &&
          _displayOrderData.length < _allOrderData.length) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(microseconds: 800));
    setState(() {
      final int startIndex = _displayOrderData.length;
      int endIndex = startIndex + _loadCount;
      if (endIndex > _allOrderData.length) {
        endIndex = _allOrderData.length;
      }
      _displayOrderData.addAll(_allOrderData.sublist(startIndex, endIndex));
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bannerPageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 生成伪造的订单数据
  List<OrderInfo> _generateFakeOrderData(int count) {
    final List<String> names = [
      "张三",
      "李四",
      "王五",
      "赵六",
      "钱七",
      "孙八",
      "周九",
      "吴十",
      "郑十一",
      "冯十二",
    ];
    final List<String> statusList = ["待处理", "处理中", "已完成", "已取消", "已驳回"];
    final List<String> questions = [
      "商品质量问题",
      "物流配送延迟",
      "退款申请处理",
      "售后客服响应慢",
      "商品与描述不符",
      "包装破损",
      "少发漏发商品",
      "发票开具问题",
    ];
    final List<String> dates = List.generate(30, (index) {
      return "2026-01-${index + 1 < 10 ? '0${index + 1}' : index + 1}";
    });
    final List<String> types = ["售后咨询", "投诉建议", "订单查询", "退款申请", "物流咨询"];
    final Random random = Random();
    return List.generate(count, (index) {
      return OrderInfo(
        names[random.nextInt(names.length)],
        statusList[random.nextInt(statusList.length)],
        questions[random.nextInt(questions.length)],
        dates[random.nextInt(dates.length)],
        types[random.nextInt(types.length)],
        "https://picsum.photos/200",
      );
    });
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
                        image: NetworkImage("https://picsum.photos/200"), // 本地图片路径
                        fit: BoxFit.cover, // 图片适配方式（关键，下文详解）
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
                                    color: Colors.white.withOpacity(0.1), // 淡色背景
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ), // 可选：添加圆角
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _createButton(CupertinoIcons.cube, () {}),
                                      _buildDivider(),
                                      _createButton(CupertinoIcons.cube, () {}),
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
                              color: Styles.themeEndColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "恭喜",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Styles.orgFontColor,
                                  ),
                                ),
                                _buildDivider(),
                                Text(
                                  "Lv.1 见习答主+10题",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Styles.mainFontColor,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.close,
                                  color: Styles.chevronRightIconColor,
                                  size: 14.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: DotProgressBar(
                                  progress: 0,
                                  height: 10,
                                  dotSize: 18,
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
                                              color: Styles.chevronRightIconColor,
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
                  Positioned(
                    top: 160,
                    left: 10.w,
                    right: 10.w,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 170),
              _buildClass(),
            ],
          ),
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
                const SizedBox(height: 10)
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
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600]!,
                    ),
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
