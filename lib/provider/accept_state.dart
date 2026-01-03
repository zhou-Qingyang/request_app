
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:quest_app/page/accept/accept.dart';

class AcceptState extends ChangeNotifier {
  List<AcceptInfo> _accepts = [];
  List<AcceptInfo> get accepts => _accepts;
  List<AcceptInfo> _generateFakeData(int count) {
    final Random random = Random();
    final List<String> titles = [
      "任务奖励",
      "签到积分",
      "邀请返现",
      "活动补贴",
      "日常收益",
      "dada123",
      "测距来及12逻辑快乐2及1将31klj",
      "12333333333333333333333333333",
      "444444444444444444444444444444",
      "123123333333333333331",
      "1233333333333"
    ];
    double minMoney = 0.50;
    double maxMoney = 3.00;
    double randomMoney = minMoney + random.nextDouble() * (maxMoney - minMoney);
    String moneyStr = randomMoney.toStringAsFixed(2);
    int minScore = 10;
    int maxScore = 100;
    return List.generate(count, (index) {
      return AcceptInfo(
        index,
        titles[(random.nextInt(titles.length) + index * 2) % titles.length],    // 随机标题
        moneyStr,
        (minScore + random.nextInt(maxScore - minScore + 1)).toString(),       // 积分字符串
      );
    });
  }

  AcceptState() {
    _accepts = _generateFakeData(10);
    _accepts.sort((a, b) => b.id.compareTo(a.id));
  }

  void addAccept(AcceptInfo accept) {
    final int newAcceptId = _accepts.first.id + 1;
    final newAccept = accept.copyWith(id: newAcceptId);
    List<AcceptInfo> newAccepts = List.from(_accepts);
    newAccepts.add(newAccept);
    newAccepts.sort((a, b) => b.id.compareTo(a.id));
    _accepts = newAccepts;
    notifyListeners();
  }

  void deleteAccept(int acceptId) {
    final index = _accepts.indexWhere((element) => element.id == acceptId);
    if(index == -1){
      return;
    }
    final List<AcceptInfo> newAccepts = List.from(_accepts);
    newAccepts.removeAt(index);
    _accepts = newAccepts;
    notifyListeners();
  }

  void updateAccept(AcceptInfo accept) {
    final index = _accepts.indexWhere((element) => element.id == accept.id);
    if (index == -1) {
      return;
    }
    final List<AcceptInfo> newAccepts = List.from(_accepts);
    newAccepts[index] = accept;
    _accepts = newAccepts;
    notifyListeners();
  }
}