import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../helper/style.dart';
import '../../provider/analysis_state.dart';
import 'analysis.dart';
import 'analysis_edit_appbar.dart';

class AnalysisEditPage extends StatefulWidget {
  const AnalysisEditPage({super.key});

  @override
  State<AnalysisEditPage> createState() => _AnalysisEditPageState();
}

class _AnalysisEditPageState extends State<AnalysisEditPage> {
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
    final List<AnalysisData> analysisList = context.select(
          (AnalysisState r) => r.analyses,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(false),
      child: Scaffold(
        backgroundColor: Styles.mainBackground,
        extendBodyBehindAppBar: true,
        appBar: AnalysisEditAppBar(
          title: Text(
            "数据分析编辑",
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
                child: analysisList.isEmpty
                    ? const Center(child: Text('暂无数据，点击右上角添加'))
                    : ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: analysisList.length,
                  itemBuilder: (context, index) {
                    return _buildAnalysisItem(analysisList[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建数据分析项
  Widget _buildAnalysisItem(AnalysisData data) {
    return Container(
      padding:  EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.date,
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xFF4e525a),
              fontWeight: FontWeight.bold,
            ),
          ),
          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 8,
            crossAxisSpacing: 20,
            mainAxisSpacing: 2,
            children: [
              _buildDataItem('订单量', data.orderCount.toString()),
              _buildDataItem('5分钟响应率', '${data.responseRate}%'),
              _buildDataItem('好评数', '${data.positiveRate}%'),
              _buildDataItem('差评数', '${data.negativeRate}%'),
              _buildDataItem('复购数', data.repeatCount.toString()),
              _buildDataItem('不限时奖励单', data.noLimitOrderCount.toString()),
              _buildDataItem('解决率', '${data.resolveRate}%'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _openEditDialog(data),
                style: TextButton.styleFrom(
                  fixedSize: Size(60, 24),
                  foregroundColor: Styles.mainFontColor,
                  side: BorderSide(
                    color: Styles.mainFontColor.withOpacity(0.1),
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
            ],
          ),
        ],
      ),
    );
  }

  // 构建单个数据项
  Widget _buildDataItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12.sp, color: Color(0xFF888888)),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 12.sp, color: Color(0xFF4e525a)),
        ),
      ],
    );
  }
  // 编辑/新增弹窗
  void _openEditDialog(AnalysisData? data) {
    // 初始化控制器
    final isAdd = data == null;
    final dateFormat = DateFormat('yyyy.MM.dd');

    final orderCountCtrl = TextEditingController(
      text: isAdd ? '' : data!.orderCount.toString(),
    );
    final responseRateCtrl = TextEditingController(
      text: isAdd ? '' : data!.responseRate.toString(),
    );
    final positiveRateCtrl = TextEditingController(
      text: isAdd ? '' : data!.positiveRate.toString(),
    );
    final negativeRateCtrl = TextEditingController(
      text: isAdd ? '' : data!.negativeRate.toString(),
    );
    final repeatCountCtrl = TextEditingController(
      text: isAdd ? '' : data!.repeatCount.toString(),
    );
    final noLimitOrderCountCtrl = TextEditingController(
      text: isAdd ? '' : data!.noLimitOrderCount.toString(),
    );
    final resolveRateCtrl = TextEditingController(
      text: isAdd ? '' : data!.resolveRate.toString(),
    );
    final dateCtrl = TextEditingController(
      text: isAdd ? dateFormat.format(DateTime.now()) : data!.date,
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            isAdd ? '新增数据分析' : '编辑数据分析',
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
                const Text('日期'),
                TextField(
                  controller: dateCtrl,
                  enabled: false, // 核心：禁用编辑
                  decoration: const InputDecoration(
                    hintText: '请输入日期（格式：2026.01.03）',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 8),
                // 订单量
                const Text('订单量'),
                TextField(
                  controller: orderCountCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '请输入订单量',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 8),
                // 5分钟响应率
                const Text('5分钟响应率（%）'),
                TextField(
                  controller: responseRateCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '请输入响应率（0-100）',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 8),
                const Text('好评数'),
                TextField(
                  controller: positiveRateCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '请输入好评数',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 8),
                const Text('差评数'),
                TextField(
                  controller: negativeRateCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '请输入差评数（0-100）',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 8),
                const Text('复购数'),
                TextField(
                  controller: repeatCountCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '请输入复购数',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 8),
                const Text('不限时奖励单'),
                TextField(
                  controller: noLimitOrderCountCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '请输入不限时奖励单',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(height: 8),
                const Text('解决率（%）'),
                TextField(
                  controller: resolveRateCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '请输入解决率',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
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
                // 表单验证
                if (dateCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('日期不能为空')),
                  );
                  return;
                }
                // 验证数字字段
                final orderCount = int.tryParse(orderCountCtrl.text);
                final responseRate = int.tryParse(responseRateCtrl.text);
                final positiveRate = int.tryParse(positiveRateCtrl.text);
                final negativeRate = int.tryParse(negativeRateCtrl.text);
                final repeatCount = int.tryParse(repeatCountCtrl.text);
                final noLimitOrderCount = int.tryParse(noLimitOrderCountCtrl.text);
                final resolveRate = int.tryParse(resolveRateCtrl.text);

                if (orderCount == null || orderCount < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('订单量必须为非负整数')),
                  );
                  return;
                }
                if (responseRate == null || responseRate < 0 || responseRate > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('响应率必须为0-100的整数')),
                  );
                  return;
                }
                if (positiveRate == null || positiveRate < 0 || positiveRate > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('好评率必须为0-100的整数')),
                  );
                  return;
                }
                if (negativeRate == null || negativeRate < 0 || negativeRate > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('差评率必须为0-100的整数')),
                  );
                  return;
                }
                if (repeatCount == null || repeatCount < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('复购数必须为非负整数')),
                  );
                  return;
                }
                if (noLimitOrderCount == null || noLimitOrderCount < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('无限额订单数必须为非负整数')),
                  );
                  return;
                }
                if (resolveRate == null || resolveRate < 0 || resolveRate > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('解决率必须为0-100的整数')),
                  );
                  return;
                }
                final analysisData = AnalysisData(
                 orderCount,
                   responseRate,
                positiveRate,
                 negativeRate,
                repeatCount,
                 noLimitOrderCount,
                resolveRate,
                dateCtrl.text,
                );
                if (isAdd) {
                } else {
                  context.read<AnalysisState>().updateAnalysis(analysisData);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isAdd ? '新增成功' : '编辑成功'),
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