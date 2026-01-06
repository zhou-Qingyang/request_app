import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:quest_app/page/analysis/analysis.dart';

class ServiceDataInfo {
  int id;
  String title;
  int data;
  int lateDayData;
  ServiceDataInfo(this.id, this.title, this.data,this.lateDayData);
  ServiceDataInfo copyWith({int? id, String? title, int? data, int? lateDayData}) {
    return ServiceDataInfo(
      id ?? this.id,
      title ?? this.title,
      data ?? this.data,
      lateDayData ?? this.lateDayData
    );
  }
}

class AnalysisState extends ChangeNotifier {
  List<ServiceDataInfo> _serviceData = [];
  List<ServiceDataInfo> get serviceData => _serviceData;
  Map<String, int> _hexagonData = {
    '用户反馈': 85,
    '服务表现': 92,
    '复购表现': 78,
    '内容质量': 95,
    '响应速度': 88,
    '原创表现': 73,
  };
  int _quoteOrderLimit = 0;
  int get quoteOrderLimit => _quoteOrderLimit;
  List<AnalysisData> _analyses = [];
  List<AnalysisData> get analyses => _analyses;
  Map<String, int> get hexagonData => _hexagonData;

  List<AnalysisData> _generate30DaysData() {
    final List<AnalysisData> data = [];
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy.MM.dd');
    final random = Random(); // 抽离Random实例，优化性能
    for (int i = 0; i < 30; i++) {
      final targetDate = now.subtract(Duration(days: i));
      final dateStr = dateFormat.format(targetDate);
      data.add(
        AnalysisData(
          _getRandomInt(50, 200, random),
          // 订单数
          _getRandomInt(80, 100, random),
          // 响应率
          _getRandomInt(85, 98, random),
          // 好评率
          _getRandomInt(1, 5, random),
          // 差评率
          _getRandomInt(10, 50, random),
          // 复购数
          _getRandomInt(5, 30, random),
          // 无限额订单数
          _getRandomInt(88, 99, random),
          // 解决率
          dateStr, // 格式化后的日期
        ),
      );
    }
    return data;
  }

  int _getRandomInt(int min, int max, Random random) {
    return min + random.nextInt(max - min + 1);
  }

  AnalysisState() {
    _analyses = _generate30DaysData();
    _analyses.sort((a, b) => b.date.compareTo(a.date));
    _serviceData = [
      ServiceDataInfo(1, "订单量", 1250, 980),
      ServiceDataInfo(2, "5分钟响应率", 3456, 3102),
      ServiceDataInfo(3, "好评数", 8920, 7543),
      ServiceDataInfo(4, "差评数", 2178, 2045),
      ServiceDataInfo(5, "复购数", 567, 489),
      ServiceDataInfo(6, "不限时奖励单", 4321, 4156),
    ];
  }

  void updateAnalysis(AnalysisData data) {
    final index = _analyses.indexWhere((item) => item.date == data.date);
    if (index == -1) {
      return;
    }
    final List<AnalysisData> newList = List.from(_analyses);
    newList[index] = data;
    _analyses = newList;
    notifyListeners();
  }


}
