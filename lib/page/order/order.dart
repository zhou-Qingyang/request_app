import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quest_app/page/order/order_appbar.dart';
import 'package:quest_app/page/widgets/main_appbar.dart';

import '../../helper/style.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
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

class _OrderPageState extends State<OrderPage> {
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
    // 模拟状态库
    final List<String> statusList = ["待处理", "处理中", "已完成", "已取消", "已驳回"];
    // 模拟问题库
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

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = MediaQuery.of(context).padding.top + 44.h;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(false),
      child: Scaffold(
        backgroundColor: Styles.mainBackground,
        extendBodyBehindAppBar: true,
        appBar: OrderAppbar(
          title: Text(
            "订单管理",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: paddingHeight),
          child: Column(
            children: [
              _buildAdvancedHorizontalList(),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: _displayOrderData.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _displayOrderData.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return _buildOrderItem(_displayOrderData[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedHorizontalList() {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        physics: const ClampingScrollPhysics(),
        itemCount: buttonTitles.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          return _buildCustomButton(
            title: buttonTitles[index],
            isSelected: isSelected,
            onTap: () => setState(() => selectedIndex = index),
          );
        },
      ),
    );
  }

  Widget _buildCustomButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.white : Colors.white,
          foregroundColor: isSelected ? Color(0xFF3b6ffb) : Color(0xFF525252),
          side: BorderSide(
            color: isSelected ? Color(0xFF486fdf) : Color(0xFFE0E0E0),
            width: 0.5,
          ),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r), // 圆角
          ),
        ),
        child: Text(title, style: TextStyle(fontSize: 12.sp)),
      ),
    );
  }

  Widget _buildOrderItem(OrderInfo order) {
    final String titleName = "来自${order.fromName}的咨询";
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  order.avatarUrl,
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                titleName,
                style: TextStyle(fontSize: 14.sp, color: Color(0xFF4e525a)),
              ),
              const Spacer(),
              Text(
                order.status,
                style: TextStyle(fontSize: 15.sp, color: Color(0xFFfd6700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.only(right: 0.w, bottom: 2.h),
                    child: Icon(
                      Icons.text_fields,
                      size: 14.sp,
                      color: Styles.mainFontColor.withOpacity(0.8),
                    ),
                  ),
                ),
                TextSpan(
                  text: order.question,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Styles.mainFontColor,
                    height: 1.4, // 行高适配
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFf7f8fe),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order.status,
                      style:  TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF526fe6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.date,
                    style: TextStyle(fontSize: 12, color: Color(0xFF4e525a)),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      print('按钮被点击');
                    },
                    style: TextButton.styleFrom(
                      fixedSize: Size(60, 24),
                      foregroundColor: Styles.mainFontColor, // 文字颜色
                      side: BorderSide(
                        color: Styles.mainFontColor.withOpacity(0.1), // 边框颜色
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: 12.w,
                      //   vertical: 4.w,
                      // ),
                    ),
                    child: Text(
                      '复制单号',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      print('按钮被点击');
                    },
                    style: TextButton.styleFrom(
                      fixedSize: Size(60, 24),
                      foregroundColor: Color(0xFF3f6ff4), // 文字颜色
                      side: BorderSide(
                        color: Color(0xFF3f6ff4).withOpacity(0.1), // 边框颜色
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r), // 圆角
                      ),
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: 8.w,
                      //   vertical: 2.w,
                      // ),
                    ),
                    child: Text(
                      '查看',
                      style: TextStyle(
                        fontSize: 12.sp,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "待处理":
        return Colors.orange;
      case "处理中":
        return Colors.blue;
      case "已完成":
        return Colors.green;
      case "已取消":
        return Colors.grey;
      case "已驳回":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
