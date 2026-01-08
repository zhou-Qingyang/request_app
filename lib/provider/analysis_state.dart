import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:quest_app/page/analysis/analysis.dart';

import '../model/question.dart';

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

  double _preTaxProfit = 122.0;
  double get preTaxProfit => _preTaxProfit;

  void updatePreTaxProfit(double profit) {
    _preTaxProfit = profit;
    notifyListeners();
  }

  void _generate30DaysData() {
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
    _analyses = data;
    _analyses.sort((a, b) => b.date.compareTo(a.date));
  }

  int _getRandomInt(int min, int max, Random random) {
    return min + random.nextInt(max - min + 1);
  }

  AnalysisState() {
    _generate30DaysData();
    _generateRandomQuestions();
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

  void updateServiceData(ServiceDataInfo data) {
    final index = _serviceData.indexWhere((item) => item.id == data.id);
    if (index == -1) {
      return;
    }
    final List<ServiceDataInfo> newList = List.from(_serviceData);
    newList[index] = data;
    _serviceData = newList;
    notifyListeners();
  }

  void updateQuoteOrderLimit(int quote){
    _quoteOrderLimit = quote;
    notifyListeners();
  }

  void updateHexagonData(String key,int value){
     final Map<String,int> newHexagonData = {..._hexagonData, key: value};
    _hexagonData = newHexagonData;
    notifyListeners();
  }

  List<QuestionInfo> _questions = [];

  List<QuestionInfo> get questions => _questions;

  // 生成随机数据
  void _generateRandomQuestions() {
    final Random random = Random();
    final List<String> titles = [
      'Flutter 页面路由问题',
      '数据库连接超时',
      'API 接口返回异常',
      '用户登录验证失败',
      '图片上传功能异常',
      '支付模块集成问题',
      '推送通知不显示',
      '列表滚动卡顿优化',
      '多语言切换问题',
      '暗黑模式适配问题',
    ];
    _questions = List.generate(10, (index) {
      final now = DateTime.now();
      final acceptTime = now.subtract(Duration(days: random.nextInt(30)));
      final paymentTime = acceptTime.add(Duration(days: random.nextInt(15) + 5));
      return QuestionInfo(
        id: index + 1,
        title: titles[index],
        expectedPaymentTime:  _formatDate(paymentTime),
        acceptTime: _formatDate(acceptTime),
        paymentAmount: (random.nextInt(5000) + 1000).toDouble(),
      );
    });
    _questions.sort((a, b) => b.acceptTime.compareTo(a.acceptTime));
    notifyListeners();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void addQuestion(QuestionInfo question) {
    final int newQuestionId = _questions.isEmpty ? 1 : _questions. first.id + 1;
    final newQuestion = question.copyWith(id: newQuestionId);
    List<QuestionInfo> newQuestions = List.from(_questions);
    newQuestions.add(newQuestion);
    newQuestions.sort((a, b) => b.id.compareTo(a. id));
    _questions = newQuestions;
    notifyListeners();
  }

  void deleteQuestion(int questionId) {
    final index = _questions. indexWhere((element) => element.id == questionId);
    if (index == -1) {
      return;
    }
    final List<QuestionInfo> newQuestions = List.from(_questions);
    newQuestions.removeAt(index);
    _questions = newQuestions;
    notifyListeners();
  }

  void updateQuestion(QuestionInfo question) {
    final index = _questions.indexWhere((element) => element.id == question.id);
    if (index == -1) {
      return;
    }
    final List<QuestionInfo> newQuestions = List.from(_questions);
    newQuestions[index] = question;
    _questions = newQuestions;
    notifyListeners();
  }
}
