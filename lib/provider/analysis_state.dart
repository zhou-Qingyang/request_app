import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:quest_app/page/analysis/analysis.dart';

class AnalysisState extends ChangeNotifier {
  List<AnalysisData> _analyses = [];

  List<AnalysisData> get analyses => _analyses;

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
