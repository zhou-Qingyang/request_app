import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/accept/accept.dart';
import 'package:quest_app/provider/accept_state.dart';
import '../../helper/style.dart';
import 'accept_edit_bar.dart';
class AcceptEditPage extends StatefulWidget {
  const AcceptEditPage({super.key});

  @override
  State<AcceptEditPage> createState() => _AcceptEditPageState();
}

class _AcceptEditPageState extends State<AcceptEditPage> {
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
    final List<AcceptInfo> accepts = context.select(
      (AcceptState r) => r.accepts,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(false),
      child: Scaffold(
        backgroundColor: Styles.mainBackground,
        extendBodyBehindAppBar: true,
        appBar: AcceptEditBar(
          onAdd: () => _openEditDialog(AcceptInfo(0, '', '', '')),
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
                  itemCount: accepts.length,
                  itemBuilder: (context, index) {
                    return _buildAcceptItem(accepts[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAcceptItem(AcceptInfo accept) {
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
            accept.title,
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF4e525a)),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w, right: 2.w),
                    child: Icon(Icons.add, size: 14.sp, color: Colors.red),
                  ),
                ),
                TextSpan(
                  text: "${accept.score}问贝",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                    // height: 1.4, // 行高适配
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w, right: 2.w),
                    child: Icon(Icons.add, size: 14.sp, color: Colors.red),
                  ),
                ),
                TextSpan(
                  text: accept.money,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.red,
                    // height: 1.4, // 行高适配
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
                  TextButton(
                    onPressed: () {
                      _openEditDialog(accept);
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
                      context.read<AcceptState>().deleteAccept(accept.id);
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


  void _openEditDialog(AcceptInfo accept) {
    final titleCtrl = TextEditingController(text: accept.title);
    final moneyCtrl = TextEditingController(text: accept.money);
    final scoreCtrl = TextEditingController(text: accept.score);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          title: accept.id == 0
              ? Text(
                  '新增抢单',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Styles.mainFontColor,
                  ),
                )
              : Text(
                  '编辑抢单',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Styles.mainFontColor,
                  ),
                ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('订单标题'),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    hintText: '请输入订单标题',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 12),
                const Text('订单金额 (元)'),
                TextField(
                  controller: moneyCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: '请输入订单金额',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 12),
                const Text('订单收益（问贝）'),
                TextField(
                  controller: scoreCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '请输入订单收益（问贝）',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                  buildCounter:
                      (
                        context, {
                        required currentLength,
                        required isFocused,
                        maxLength,
                      }) => null, // 隐藏字符计数器
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
                if (titleCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('订单标题不能为空')));
                  return;
                }
                if (moneyCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('订单金额不能为空')));
                  return;
                }
                try {
                  double.parse(moneyCtrl.text);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('订单金额必须为有效数字')));
                  return;
                }
                if (scoreCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('订单评分不能为空')));
                  return;
                }
                int score = int.tryParse(scoreCtrl.text) ?? 0;
                if (score < 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('订单问贝必须大于等于10')),
                  );
                  return;
                }
                final updatedAccept = accept.copyWith(
                  title: titleCtrl.text,
                  money: moneyCtrl.text,
                  score: scoreCtrl.text,
                );
                if (accept.id == 0) {
                  context.read<AcceptState>().addAccept(updatedAccept);
                } else {
                  context.read<AcceptState>().updateAccept(updatedAccept);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(accept.id == 0 ? '新增成功' : '编辑成功'),
                    duration: const Duration(seconds: 1),
                  ),
                );
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
}
