import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/accept/accept.dart';
import 'package:quest_app/provider/accept_state.dart';
import 'package:quest_app/provider/order_state.dart';
import '../../helper/style.dart';
import 'withDraw_edit_appbar.dart';


class WithDrawEditPage extends StatefulWidget {
  const WithDrawEditPage({super.key});

  @override
  State<WithDrawEditPage> createState() => _WithDrawEditPageState();
}

class _WithDrawEditPageState extends State<WithDrawEditPage> {
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
    final double paddingHeight = MediaQuery.of(context).padding.top + 44.h;
    final List<WithDrawInfo> withDraws = context.select(
      (OrderState r) => r.withDraws,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(false),
      child: Scaffold(
        backgroundColor: Styles.mainBackground,
        extendBodyBehindAppBar: true,
        appBar: WithDrawEditBar(
          onAdd: () => _openEditDialog(WithDrawInfo(0, '', '')),
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
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: withDraws.length,
                  itemBuilder: (context, index) {
                    return _buildWithDrawItem(withDraws[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWithDrawItem(WithDrawInfo withDraw) {
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
            withDraw.date,
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF4e525a)),
          ),
          const SizedBox(height: 8),
          Text(
            "¥ ${withDraw.amount}",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.red,
              // height: 1.4, // 行高适配
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
                      _openEditDialog(withDraw);
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
                       context.read<OrderState>().deleteWithDraw(withDraw.id);
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

  void _openEditDialog(WithDrawInfo withDraw) {
    final dateCtrl = TextEditingController(text: withDraw.date);
    final amountCtrl = TextEditingController(text: withDraw.amount);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            withDraw.id == 0 ? '新增提现' :  '编辑提现',
            style: TextStyle(
              fontSize: 16.sp,
              color: Styles.mainFontColor,
            ),
          ),
          content: SingleChildScrollView(
            child:  Column(
              mainAxisSize:  MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment. start,
              children: [
                const Text('提现日期'),
                TextField(
                  controller: dateCtrl,
                  decoration: const InputDecoration(
                    hintText: '请选择提现日期时间',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical:  8,
                    ),
                    suffixIcon: Icon(Icons. calendar_today),
                  ),
                  style: TextStyle(fontSize:  14.sp),
                  readOnly: true,
                  onTap: () async {
                    // 第一步：选择日期
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime. now(),
                      firstDate:  DateTime(2020),
                      lastDate: DateTime(2030),
                    );

                    if (pickedDate != null) {
                      // 第二步：选择时间
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context:  context,
                        initialTime:  TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        // 组合日期和时间
                        final DateTime fullDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                          DateTime.now().second, // 当前秒数
                        );

                        // 格式化为：2026-01-06 14:30:25
                        final formattedDate =
                            '${fullDateTime.year}年'
                            '${fullDateTime.month.toString().padLeft(2, '0')}月'
                            '${fullDateTime.day.toString().padLeft(2, '0')}日 '
                            '${fullDateTime.hour.toString().padLeft(2, '0')}:'
                            '${fullDateTime.minute.toString().padLeft(2, '0')}:'
                            '${fullDateTime. second.toString().padLeft(2, '0')}';
                        dateCtrl.text = formattedDate;
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),
                const Text('提现金额 (元)'),
                TextField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: '请输入提现金额',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
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
                if (dateCtrl.text.isEmpty) {
                  ScaffoldMessenger. of(context).showSnackBar(
                    const SnackBar(content: Text('提现日期不能为空')),
                  );
                  return;
                }
                if (amountCtrl.text.isEmpty) {
                  ScaffoldMessenger. of(context).showSnackBar(
                    const SnackBar(content: Text('提现金额不能为空')),
                  );
                  return;
                }
                try {
                  double.parse(amountCtrl.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('提现金额必须为有效数字')),
                  );
                  return;
                }
                final updatedWithDraw = withDraw.copyWith(
                  date: dateCtrl.text,
                  amount: amountCtrl.text,
                );
                if (withDraw.id == 0) {
                   context.read<OrderState>().addWithDraw(updatedWithDraw);
                } else {
                   context.read<OrderState>().updateWithDraw(updatedWithDraw);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(withDraw.id == 0 ?  '新增成功' : '编辑成功'),
                    duration: const Duration(seconds:  1),
                  ),
                );
              },
              child:  Text(
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
}
