import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/analysis/service_app_bar.dart';
import 'package:quest_app/provider/analysis_state.dart';

import '../../helper/style.dart';

class DataManagementPage extends StatefulWidget {
  const DataManagementPage({Key? key}) : super(key: key);

  @override
  State<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage> {
  // List<ServiceDataInfo> _serviceData = [
  //   ServiceDataInfo(1, "订单量", 1250, 980),
  //   ServiceDataInfo(2, "5分钟响应率", 3456, 3102),
  //   ServiceDataInfo(3, "好评数", 8920, 7543),
  //   ServiceDataInfo(4, "差评数", 2178, 2045),
  //   ServiceDataInfo(5, "复购数", 567, 489),
  //   ServiceDataInfo(6, "不限时奖励单", 4321, 4156),
  // ];
  // int _quoteOrderLimit = 100;
  // int get quoteOrderLimit => _quoteOrderLimit;
  // Map<String, int> _hexagonData = {
  //   '用户反馈': 85,
  //   '服务表现': 92,
  //   '复购表现': 78,
  //   '内容质量': 95,
  //   '响应速度': 88,
  //   '原创表现': 73,
  // };

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = MediaQuery
        .of(context)
        .padding
        .top + 42.h;
    return Scaffold(
      backgroundColor: Styles.mainBackground,
      extendBodyBehindAppBar: true,
      appBar: ServiceEditAppBar(
        title: Text(
          "编辑页面",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: paddingHeight, left: 10.w, right: 10.w),
        children: [
          _buildSectionTitle('服务数据管理'),
          _buildServiceDataCard(),
          SizedBox(height: 20.h),
          _buildSectionTitle('抢单量上限'),
          _buildQuoteOrderLimitCard(),
          SizedBox(height: 20.h),
          _buildSectionTitle('六边形数据管理'),
          _buildHexagonDataCard(),
        ],
      ),
    );
  }

  // 标题组件
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ========== 第一种：服务数据列表卡片 ==========
  Widget _buildServiceDataCard() {
    final List<ServiceDataInfo> _serviceData = context.select((
        AnalysisState a) => a.serviceData);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          ..._serviceData.map((data) {
            return ListTile(
              title: Text(
                data.title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                '今日:  ${data.data}  昨日: ${data.lateDayData}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              trailing: IconButton(
                icon: Icon(
                    Icons.edit, size: 20, color: const Color(0xFF3f6ff4)),
                onPressed: () => _openServiceDataDialog(data),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // 服务数据编辑对话框
  void _openServiceDataDialog(ServiceDataInfo serviceData) {
    final titleCtrl = TextEditingController(text: serviceData.title);
    final dataCtrl = TextEditingController(text: serviceData.data.toString());
    final lateDayDataCtrl = TextEditingController(
      text: serviceData.lateDayData.toString(),
    );
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '编辑服务数据',
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('数据标题'),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      hintText: '请输入数据标题',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 12.h),
                  const Text('今日数据'),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: dataCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '请输入今日数据',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 12.h),
                  const Text('昨日数据'),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: lateDayDataCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '请输入昨日数据',
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
                child: Text('取消', style: TextStyle(fontSize: 14.sp)),
              ),
              TextButton(
                onPressed: () {
                  if (titleCtrl.text.isEmpty) {
                    _showSnackBar('标题不能为空');
                    return;
                  }
                  if (dataCtrl.text.isEmpty) {
                    _showSnackBar('今日数据不能为空');
                    return;
                  }
                  if (lateDayDataCtrl.text.isEmpty) {
                    _showSnackBar('昨日数据不能为空');
                    return;
                  }

                  final data = int.tryParse(dataCtrl.text);
                  final lateDayData = int.tryParse(lateDayDataCtrl.text);

                  if (data == null || lateDayData == null) {
                    _showSnackBar('数据必须为有效数字');
                    return;
                  }
                  context.read<AnalysisState>().updateServiceData(
                      ServiceDataInfo(
                          serviceData.id, serviceData.title, data, lateDayData));

                  Navigator.pop(context);
                  _showSnackBar('修改成功');
                },
                child: Text(
                  '保存',
                  style: TextStyle(
                      fontSize: 14.sp, color: const Color(0xFF3f6ff4)),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildQuoteOrderLimitCard() {
    final int _quoteOrderLimit = context.select((
        AnalysisState a) => a.quoteOrderLimit);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          '抢单量上限',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '当前限制: $_quoteOrderLimit 单',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, size: 20, color: const Color(0xFF3f6ff4)),
          onPressed: () => _openQuoteOrderLimitDialog(_quoteOrderLimit),
        ),
      ),
    );
  }

  // 报价订单限制编辑对话框
  void _openQuoteOrderLimitDialog(int quoteOrderLimit) {
    final limitCtrl = TextEditingController(text: quoteOrderLimit.toString());
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '编辑抢单量上限',
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('抢单量上限'),
                SizedBox(height: 8.h),
                TextField(
                  controller: limitCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '请输入抢单量上限',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    suffixText: '单',
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消', style: TextStyle(fontSize: 14.sp)),
              ),
              TextButton(
                onPressed: () {
                  if (limitCtrl.text.isEmpty) {
                    _showSnackBar('抢单量上限不能为空');
                    return;
                  }
                  final limit = int.tryParse(limitCtrl.text);
                  if (limit == null || limit < 0) {
                    _showSnackBar('请输入有效的数字（≥0）');
                    return;
                  }
                  context.read<AnalysisState>().updateQuoteOrderLimit(limit);
                  Navigator.pop(context);
                  _showSnackBar('修改成功');
                },
                child: Text(
                  '保存',
                  style: TextStyle(
                      fontSize: 14.sp, color: const Color(0xFF3f6ff4)),
                ),
              ),
            ],
          ),
    );
  }

  // ========== 第三种：六边形数据卡片 ==========
  Widget _buildHexagonDataCard() {
    final Map<String,int> _hexagonData = context.select((
        AnalysisState a) => a.hexagonData);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          ..._hexagonData.entries.map((entry) {
            return ListTile(
              title: Text(
                entry.key,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              subtitle: LinearProgressIndicator(
                value: entry.value / 100,
                backgroundColor: Colors.grey[200],
                color: const Color(0xFF3f6ff4),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${entry.value}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3f6ff4),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(
                        Icons.edit, size: 20, color: const Color(0xFF3f6ff4)),
                    onPressed: () =>
                        _openHexagonDataDialog(entry.key, entry.value),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // 六边形数据编辑对话框
  void _openHexagonDataDialog(String key, int value) {
    final valueCtrl = TextEditingController(text: value.toString());

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '编辑 $key',
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('当前值:  $value'),
                SizedBox(height: 12.h),
                const Text('新数值 (0-100)'),
                SizedBox(height: 8.h),
                TextField(
                  controller: valueCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '请输入数值 (0-100)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 12.h),
                // 滑块
                Slider(
                  value: double.tryParse(valueCtrl.text) ?? value.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: valueCtrl.text,
                  activeColor: const Color(0xFF3f6ff4),
                  onChanged: (newValue) {
                    valueCtrl.text = newValue.toInt().toString();
                    (context as Element).markNeedsBuild();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消', style: TextStyle(fontSize: 14.sp)),
              ),
              TextButton(
                onPressed: () {
                  if (valueCtrl.text.isEmpty) {
                    _showSnackBar('数值不能为空');
                    return;
                  }
                  final newValue = int.tryParse(valueCtrl.text);
                  if (newValue == null || newValue < 0 || newValue > 100) {
                    _showSnackBar('请输入0-100之间的数字');
                    return;
                  }
                  context.read<AnalysisState>().updateHexagonData(key,newValue);
                  Navigator.pop(context);
                  _showSnackBar('修改成功');
                },
                child: Text(
                  '保存',
                  style: TextStyle(
                      fontSize: 14.sp, color: const Color(0xFF3f6ff4)),
                ),
              ),
            ],
          ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
