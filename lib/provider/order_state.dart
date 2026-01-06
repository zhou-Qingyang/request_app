import 'dart:math';
import 'package:flutter/cupertino.dart';

import '../page/order/order.dart';

class WithDrawInfo {
  int id;
  String date;
  String amount;

  WithDrawInfo(this.id, this.amount, this.date);

  WithDrawInfo copyWith({int? id, String? date, String? amount}) {
    return WithDrawInfo(
      id ?? this.id,
      amount ?? this.amount,
      date ?? this.date,
    );
  }
}

class OrderState extends ChangeNotifier {
  List<OrderInfo> _orders = [];
  List<WithDrawInfo> _withDraws = [];

  double get totalAmount {
    if (_withDraws.isEmpty) return 0.0;
    return _withDraws.fold(0.0, (sum, item) {
      try {
        return sum + double. parse(item.amount);
      } catch (e) {
        return sum;
      }
    });
  }

  String get formattedTotalAmount {
    return totalAmount.toStringAsFixed(2);
  }

  List<WithDrawInfo> get withDraws {
    final sorted = List<WithDrawInfo>.from(_withDraws);
    sorted.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.date.replaceAll(' ', 'T'));
        final dateB = DateTime.parse(b.date.replaceAll(' ', 'T'));
        return dateB.compareTo(dateA);
      } catch (e) {
        return b.date.compareTo(a.date);
      }
    });
    return sorted;
  }

  List<OrderInfo> get orders => _orders;

  List<OrderInfo> _generateFakeOrderData(int count) {
    final List<String> names = [
      "张三",
      "李四",
      "王五",
      "赵六",
      "钱七",
      "孙八",
      "周九",
      "吴十",
      "郑十一",
      "冯十二",
    ];
    final List<String> statusList = ["已完成", "已退款"];
    final List<String> questions = [
      "商品质量问题",
      "物流配送延迟",
      "退款申请处理",
      "售后客服响应慢",
      "商品与描述不符",
      "包装破损",
      "少发漏发商品",
      "发票开具问题",
    ];
    List<String> dates = List.generate(30, (index) {
      return "2026-01-${index + 1 < 10 ? '0${index + 1}' : index + 1}";
    });
    final List<String> types = ["优质", "已解决", "待判定"];
    final Random random = Random();
    return List.generate(count, (index) {
      return OrderInfo(
        index,
        names[random.nextInt(names.length)],
        statusList[random.nextInt(statusList.length)],
        questions[random.nextInt(questions.length)],
        dates[random.nextInt(dates.length)],
        types[random.nextInt(types.length)],
        "https://picsum.photos/200/300?random=${random.nextInt(100)}",
      );
    });
  }

  OrderState() {
    _orders = _generateFakeOrderData(10);
    _orders.sort((a, b) => b.id.compareTo(a.id));
    _withDraws = List.generate(
      4,
      (i) => WithDrawInfo(
        i + 1,
        (80 + i * 2.5).toStringAsFixed(2), // 金额变化
        "2025年12月${(i + 1).toString().padLeft(2, '0')}日 18:18:${(10 + i).toString().padLeft(2, '0')}", // 日期变化
      ),
    );
  }

  void addOrder(OrderInfo order) {
    final int newOrderId = _orders.first.id + 1;
    final newOrder = order.copyWith(
      id: newOrderId,
      avatarUrl: "https://picsum.photos/200/300?random=${Random().nextInt(10)}",
    );
    List<OrderInfo> newOrders = List.from(_orders);
    newOrders.add(newOrder);
    newOrders.sort((a, b) => b.id.compareTo(a.id));
    _orders = newOrders;
    notifyListeners();
  }

  void deleteOrder(int orderId) {
    final index = _orders.indexWhere((element) => element.id == orderId);
    if (index == -1) {
      return;
    }
    final List<OrderInfo> newOrders = List.from(_orders);
    newOrders.removeAt(index);
    _orders = newOrders;
    notifyListeners();
  }

  void updateOrder(OrderInfo order) {
    final index = _orders.indexWhere((element) => element.id == order.id);
    if (index == -1) {
      return;
    }
    final List<OrderInfo> newOrders = List.from(_orders);
    newOrders[index] = order;
    _orders = newOrders;
    notifyListeners();
  }

  void addWithDraw(WithDrawInfo withDraw) {
    final int newWithDrawId = _withDraws.first.id + 1;
    final WithDrawInfo newWithDraw = withDraw.copyWith(id: newWithDrawId);
    List<WithDrawInfo> newWithDrawList = List.from(_withDraws);
    newWithDrawList.add(newWithDraw);
    _withDraws = newWithDrawList;
    notifyListeners();
  }

  void deleteWithDraw(int withDrawId) {
    final index = _withDraws.indexWhere((element) => element.id == withDrawId);
    if (index == -1) {
      return;
    }
    final List<WithDrawInfo> newWithDraw = List.from(_withDraws);
    newWithDraw.removeAt(index);
    _withDraws = newWithDraw;
    notifyListeners();
  }

  void updateWithDraw(WithDrawInfo withDraw) {
    final index = _withDraws.indexWhere((element) => element.id == withDraw.id);
    if (index == -1) {
      return;
    }
    final List<WithDrawInfo> newWithDraw = List.from(_withDraws);
    newWithDraw[index] = withDraw;
    _withDraws = newWithDraw;
    notifyListeners();
  }
}
