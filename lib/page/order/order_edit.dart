import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/order/order_appbar.dart';
import 'package:quest_app/page/order/order_edit_bar.dart';
import 'package:quest_app/page/widgets/main_appbar.dart';
import 'package:quest_app/provider/order_state.dart';

import '../../helper/style.dart';
import 'order.dart';

class OrderEditPage extends StatefulWidget {
  const OrderEditPage({super.key});

  @override
  State<OrderEditPage> createState() => _OrderEditPageState();
}

class _OrderEditPageState extends State<OrderEditPage> {
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
    final List<OrderInfo> _displayOrderData = context.select(
      (OrderState r) => r.orders,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(false),
      child: Scaffold(
        backgroundColor: Styles.mainBackground,
        extendBodyBehindAppBar: true,
        appBar: OrderEditAppbar(
          //    this.id,
          //     this.fromName,
          //     this.status,
          //     this.question,
          //     this.date,
          //     this.type,
          //     this.avatarUrl,
          onAdd: () => _openEditDialog(
            OrderInfo(0, "", "已完成", "", "2026-01-01", "已解决", ""),
          ),
          title: Text(
            "编辑界面",
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
              // _buildAdvancedHorizontalList(),
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
    final (bgColor, fontColor) = _getStatusColor(order.type);
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
                      _openEditDialog(order);
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
                      '编辑',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      context.read<OrderState>().deleteOrder(order.id);
                    },
                    style: TextButton.styleFrom(
                      fixedSize: Size(60, 24),
                      foregroundColor: Colors.red, // 文字颜色
                      side: BorderSide(
                        color: Colors.red.withOpacity(0.1), // 边框颜色
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r), // 圆角
                      ),
                    ),
                    child: Text('删除', style: TextStyle(fontSize: 12.sp)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  final List<String> _statusOptions = ['已完成', '已退款'];
  final List<String> _typeOptions = ['已解决', '待判定', '优质'];

  void _openEditDialog(OrderInfo order) {
    final fromNameCtrl = TextEditingController(text: order.fromName);
    final questionCtrl = TextEditingController(text: order.question);
    String selectedStatus = order.status;
    String selectedType = order.type;
    DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(order.date);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          title: order.id == 0
              ? Text(
                  '新增订单',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Styles.mainFontColor,
                  ),
                )
              : Text(
                  '编辑订单',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Styles.mainFontColor,
                  ),
                ),
          content: SingleChildScrollView(
            // 适配小屏幕滚动
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('客户名称'),
                TextField(
                  controller: fromNameCtrl,
                  decoration: const InputDecoration(
                    hintText: '请输入来源名称',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 12),
                const Text('问题描述'),
                TextField(
                  controller: questionCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: '请输入问题描述',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 12),
                // 5. 日期选择器
                const Text('日期'),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2026, 12, 31),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF3f6ff4), // 主题色
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(selectedDate),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Styles.mainFontColor,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('订单状态'),
                Wrap(
                  spacing: 8.w,
                  children: _statusOptions.map((status) {
                    return ChoiceChip(
                      label: Text(status, style: TextStyle(fontSize: 12.sp)),
                      selected: selectedStatus == status,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => selectedStatus = status);
                        }
                      },
                      avatar: null,
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF3f6ff4).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: selectedStatus == status
                            ? const Color(0xFF3f6ff4)
                            : Styles.mainFontColor,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const Text('订单类型'),
                Wrap(
                  spacing: 8.w,
                  children: _typeOptions.map((type) {
                    return ChoiceChip(
                      label: Text(type, style: TextStyle(fontSize: 12.sp)),
                      selected: selectedType == type,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => selectedType = type);
                        }
                      },
                      avatar: null,
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFFfd6700).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: selectedType == type
                            ? const Color(0xFFfd6700)
                            : Styles.mainFontColor,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '取消',
                style: TextStyle(fontSize: 14.sp, color: Styles.mainFontColor),
              ),
            ),
            TextButton(
              onPressed: () {
                if (fromNameCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('来源名称不能为空')));
                  return;
                }
                if (questionCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('问题描述不能为空')));
                  return;
                }
                final updatedOrder = order.copyWith(
                  fromName: fromNameCtrl.text,
                  question: questionCtrl.text,
                  status: selectedStatus,
                  type: selectedType,
                  date: DateFormat('yyyy-MM-dd').format(selectedDate),
                );
                if(order.id == 0){
                  context.read<OrderState>().addOrder(updatedOrder);
                }else {
                  context.read<OrderState>().updateOrder(updatedOrder);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('编辑成功')));
              },
              child: Text(
                '保存',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF3f6ff4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) _getStatusColor(String type) {
    switch (type) {
      case "优质":
        return (Color(0xFFebf7ee), Color(0xFF52ad6d));
      case "已解决":
        return (Color(0xFFf7f8fe), Color(0xFF4e6ef1));
      case "待判定":
        return (Color(0xFFffeee5), Color(0xFFfb6709));
      default:
        return (Colors.red, Colors.red);
    }
  }
}
