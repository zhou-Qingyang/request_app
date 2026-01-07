import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/accept/accept.dart';
import 'package:quest_app/page/analysis/pay_ment_edit_appbar.dart';
import 'package:quest_app/page/analysis/payment_appbar.dart';
import 'package:quest_app/provider/accept_state.dart';
import '../../helper/style.dart';
import '../../provider/order_state.dart';


class PaymentEditPage extends StatefulWidget {
  const PaymentEditPage({super.key});

  @override
  State<PaymentEditPage> createState() => _PaymentEditPageState();
}

class _PaymentEditPageState extends State<PaymentEditPage> {
  final ScrollController _scrollController = ScrollController();
  DateTime _selectedDate = DateTime.now();
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
    final double paddingHeight = MediaQuery.of(context).padding.top + 44.h;
    final List<PaymentRecord> paymentRecords = context.select((OrderState r) => r.paymentRecords);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(false),
      child: Scaffold(
        backgroundColor: Styles.mainBackground,
        extendBodyBehindAppBar: true,
        appBar: PaymentEditBar(
          onAdd: () => _openEditDialog(null),
          title: Text(
            "编辑页面",
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
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: paymentRecords.length,
                  itemBuilder: (context, index) {
                    return _buildPaymentItem(paymentRecords[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentItem(PaymentRecord paymentRecord) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${paymentRecord.paymentDate.year}年${paymentRecord.paymentDate.month}月${paymentRecord.paymentDate.day}日",
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: paymentRecord.amount.toStringAsFixed(2) + " 元",
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
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
                  TextButton(
                    onPressed: () {
                     _openEditDialog(paymentRecord);
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
                      context.read<OrderState>().deletePaymentRecord(paymentRecord.id);
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

  // 编辑/新增弹窗表单（仅保留金额和日期字段）
  void _openEditDialog(PaymentRecord? record) {
    final isAdd = record == null;

    // 初始化控制器
    final amountCtrl = TextEditingController(
      text: isAdd ? '' : record!.amount.toStringAsFixed(2),
    );

    // 初始化选中日期
    _selectedDate = isAdd ? DateTime.now() : record!.paymentDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            isAdd ? '新增打款记录' : '编辑打款记录',
            style: TextStyle(
              fontSize: 16.sp,
              color: Styles.mainFontColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 打款金额
                Text(
                  '打款金额 (元)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    // 限制只能输入数字和小数点，且小数点后最多两位
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
                  ],
                  decoration: InputDecoration(
                    hintText: '请输入打款金额，如：100.00',
                    hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.r),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.r),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.r),
                      borderSide: BorderSide(color: const Color(0xFF3f6ff4)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 12.h),

                // 打款日期
                Text(
                  '打款日期',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () async {
                    // 打开日期选择器
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: const Color(0xFF3f6ff4),
                            ),
                            dialogBackgroundColor: Colors.white,
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日",
                          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 16.sp,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '取消',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Styles.mainFontColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // 表单校验
                if (!_validateForm(amountCtrl.text)) {
                  return;
                }
                // 构建数据对象
                final double amount = double.parse(amountCtrl.text.trim());
                final PaymentRecord paymentRecord = isAdd
                    ? PaymentRecord(
                  id: 0, // 临时ID，新增方法会自动生成
                  paymentDate: _selectedDate,
                  amount: amount,
                )
                    : record!.copyWith(
                  paymentDate: _selectedDate,
                  amount: amount,
                );
                // 调用增/改方法
                if (isAdd) {
                  context.read<OrderState>().addPaymentRecord(paymentRecord);
                } else {
                  context.read<OrderState>().updatePaymentRecord(paymentRecord);
                }
                // 关闭弹窗并提示
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isAdd ? '新增记录成功' : '编辑记录成功',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    duration: const Duration(seconds: 1),
                    backgroundColor: const Color(0xFF3f6ff4),
                  ),
                );
              },
              child: Text(
                '保存',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF3f6ff4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 表单校验（仅校验金额）
  bool _validateForm(String amount) {
    // 金额校验
    if (amount.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('打款金额不能为空')),
      );
      return false;
    }

    double? amountValue;
    try {
      amountValue = double.parse(amount.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('打款金额必须为有效数字')),
      );
      return false;
    }

    if (amountValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('打款金额必须大于0')),
      );
      return false;
    }

    return true;
  }

}
