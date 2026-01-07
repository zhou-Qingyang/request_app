class QuestionInfo {
  final int id;
  final String title; // 问题标题
  final String expectedPaymentTime; // 预计打款时间
  final String acceptTime; // 接单时间
  final String status; // 状态（写死）
  final String reason; // 原因（写死）
  final double paymentAmount; // 支付金额

  QuestionInfo({
    required this.id,
    required this.title,
    required this. expectedPaymentTime,
    required this.acceptTime,
    this.status = '已完成', // 默认写死
    this.reason = '正常结算', // 默认写死
    required this.paymentAmount,
  });

  QuestionInfo copyWith({
    int? id,
    String? title,
    String? expectedPaymentTime,
    String? acceptTime,
    String? status,
    String? reason,
    double? paymentAmount,
  }) {
    return QuestionInfo(
      id: id ?? this. id,
      title: title ??  this.title,
      expectedPaymentTime: expectedPaymentTime ??  this.expectedPaymentTime,
      acceptTime: acceptTime ?? this.acceptTime,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      paymentAmount: paymentAmount ?? this.paymentAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'expectedPaymentTime': expectedPaymentTime,
      'acceptTime': acceptTime,
      'status': status,
      'reason': reason,
      'paymentAmount': paymentAmount,
    };
  }

  factory QuestionInfo. fromJson(Map<String, dynamic> json) {
    return QuestionInfo(
      id: json['id'],
      title: json['title'],
      expectedPaymentTime: json['expectedPaymentTime'],
      acceptTime: json['acceptTime'],
      status: json['status'] ?? '已完成',
      reason: json['reason'] ?? '正常结算',
      paymentAmount: json['paymentAmount']. toDouble(),
    );
  }
}