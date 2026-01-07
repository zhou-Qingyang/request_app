import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/analysis/payment_appbar.dart';
import '../../helper/style.dart';
import '../../provider/order_state.dart';



class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.mainBackground,
      extendBodyBehindAppBar: true,
      appBar: PaymentAppBar(
        title: Text(
          "打款明细",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHeadDataCenter(),
          _buildPaymentList(),
        ],
      ),
    );
  }

  Widget _buildHeadDataCenter() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff386cfb), // 起始色（原主题色+透明度）
                Color(0xff386cfb),
                Color(0xfff5f5f5)
              ],
              stops: const [0.0, 0.8, 1.0],
            ),
          ),
          child: Text("ces1"),
        ),
        Positioned(
          top: 80,
          left: 10.w,
          right: 10.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 开启列的水平居中
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: RichText(
                  textAlign: TextAlign.center, // 设置文本居中
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "0.00",
                        style: TextStyle(
                          fontSize: 32.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.w, bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "提现",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 2.w), // 增加文字和图标间距
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4.h), // 增加两行之间的间距，提升视觉效果
              Center(
                child: RichText(
                  textAlign: TextAlign.center, // 设置文本居中
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "可提现余额(元)",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[400]!,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.w), // 增加文字和图标间距
                          child: Icon(
                            Icons.help_outline,
                            size: 14.sp,
                            color: Colors.grey[400]!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsetsGeometry.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "85.34",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center, // 设置文本居中
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "累计收益(元)",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[400]!,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.w),
                                    child: Icon(
                                      Icons.help_outline,
                                      size: 14.sp,
                                      color: Colors.grey[400]!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "85.34",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center, // 设置文本居中
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "累计收益(元)",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[400]!,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2.w),
                                    child: Icon(
                                      Icons.help_outline,
                                      size: 14.sp,
                                      color: Colors.grey[400]!,
                                    ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getChineseMonth(int month) {
    final List<String> chineseMonths = [
      "一月", "二月", "三月", "四月", "五月", "六月",
      "七月", "八月", "九月", "十月", "十一月", "十二月"
    ];
    return chineseMonths[month - 1];
  }

  Widget _buildPaymentList() {
    final List<PaymentRecord> paymentRecords = context.select((OrderState r) => r.paymentRecords);
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...paymentRecords.map((record) {
              return Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical:10,horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "打款记录",
                        style:  TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${record.paymentDate.year}年${record.paymentDate.month}月收益打款",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center, // 设置文本居中
                            text: TextSpan(
                              children: [
                                TextSpan(
                                 text: "${record.amount.toStringAsFixed(2)}元",
                                  style:  TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "打款日期:${record.paymentDate.year}-${record.paymentDate.month}-${record.paymentDate.day}",
                        style:  TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
