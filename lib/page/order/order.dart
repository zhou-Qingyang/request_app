import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/order/order_appbar.dart';
import 'package:quest_app/page/widgets/main_appbar.dart';
import 'package:quest_app/provider/order_state.dart';

import '../../helper/style.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class OrderInfo {
  final int id;
  final String fromName;
  final String avatarUrl;
  final String status;
  final String question;
  final String date;
  final String type;

  OrderInfo(
    this.id,
    this.fromName,
    this.status,
    this.question,
    this.date,
    this.type,
    this.avatarUrl,
  );

  OrderInfo copyWith({
    int? id,
    String? fromName,
    String? avatarUrl,
    String? status,
    String? question,
    String? date,
    String? type,
  }) {
    return OrderInfo(
      id ?? this.id,
      fromName ?? this.fromName,
      status ?? this.status,
      question ?? this.question,
      date ?? this.date,
      type ?? this.type,
      avatarUrl ?? this.avatarUrl,
    );
  }
}

class _OrderPageState extends State<OrderPage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final List<String> buttonTitles = ['全部', '已预约', '待应答', '进行中', '已完成', '退款'];
  int selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final double paddingHeight = MediaQuery.of(context).padding.top + 44.h;
    final List<OrderInfo> _displayOrderData = context.select((OrderState r) => r.orders);
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
      height: 50,
      padding: const EdgeInsets.only(top: 15,bottom: 10),
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
    final (bgColor,fontColor) = _getStatusColor(order.type);
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
                      color: bgColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order.type,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: fontColor,
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

  (Color,Color) _getStatusColor(String type) {
    switch (type) {
      case "优质":
        return (Color(0xFFebf7ee),Color(0xFF52ad6d));
      case "已解决":
        return (Color(0xFFf7f8fe),Color(0xFF4e6ef1));
      case "待判定":
        return (Color(0xFFffeee5),Color(0xFFfb6709));
      default:
         return (Colors.red,Colors.red);
    }
  }
}
