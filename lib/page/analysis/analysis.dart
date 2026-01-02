import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quest_app/page/widgets/main_appbar.dart';

import '../../helper/style.dart';
import 'analysis_appbar.dart';

class AnalysisData {
  final int orderCount;
  final int responseRate;
  final int positiveRate;
  final int negativeRate;
  final int repeatCount;
  final int noLimitOrderCount;
  final int resolveRate;

  AnalysisData(
    this.orderCount,
    this.responseRate,
    this.positiveRate,
    this.negativeRate,
    this.repeatCount,
    this.noLimitOrderCount,
    this.resolveRate,
  );
}

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  late Map<String, AnalysisData> _analysisDataMap;
  final List<String> _tableHeaders = [
    '日期',
    '订单量',
    '5分钟响应率',
    '复购数',
    '好评数',
    '差评数',
    '解决率',
  ];
  int selectedIndex = 0;
  int selectedServiceDataIndex = 0;
  int trendIndex = 0;
  int filterIndex = 0;
  final List<String> filterTitles = ['订单量',
    '5分钟响应率',
    '复购数',
    '好评数',
    '差评数',
    '解决率',];

  final List<String> tabTitles = ['服务分析', '商品分析', '收益分析'];
  final List<String> serviceDataTitles = ['今日', '近7天', '近30天'];
  final List<String> trendTitles = ['近7天', '近30天'];
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> images = [
    "https://picsum.photos/1920/1080",
    "https://picsum.photos/1920/1080",
    "https://picsum.photos/1920/1080",
    "https://picsum.photos/1920/1080",
  ];
  int _currentBannerPage = 0;

  @override
  void initState() {
    super.initState();
    _analysisDataMap = _generate30DaysData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Map<String, AnalysisData> _generate30DaysData() {
    final Map<String, AnalysisData> dataMap = {};
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy.MM.dd');
    // 生成近30天日期 + 随机模拟数据
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: 29 - i));
      final dateStr = dateFormat.format(date);

      dataMap[dateStr] = AnalysisData(
        _getRandomInt(50, 200),
        // 订单数
        _getRandomInt(80, 100),
        // 响应率
        _getRandomInt(85, 98),
        // 好评率
        _getRandomInt(1, 5),
        // 差评率
        _getRandomInt(10, 50),
        // 复购数
        _getRandomInt(5, 30),
        // 无限额订单数
        _getRandomInt(88, 99), // 解决率
      );
    }
    return dataMap;
  }

  int _getRandomInt(int min, int max) {
    return min + (max - min) * DateTime.now().microsecond % (max - min + 1);
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = MediaQuery.of(context).padding.top + 44.h;
    return Scaffold(
      backgroundColor: Styles.mainBackground,
      extendBodyBehindAppBar: true,
      appBar: AnalysisAppbar(
        title: Text(
          "数据分析",
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
          children: [_buildAdvancedHorizontalList(), _buildPageView()],
        ),
      ),
    );
  }

  Widget _buildAdvancedHorizontalList() {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(top: 5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: List.generate(tabTitles.length, (index) {
          bool isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              child: _buildTabItem(
                title: tabTitles[index],
                isSelected: isSelected,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabItem({required String title, required bool isSelected}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.black : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 20,
          height: 2,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF889cf7) : Colors.transparent,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        itemCount: tabTitles.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildFirstPage();
          }
          return Container(
            alignment: Alignment.center,
            child: Text(
              '${tabTitles[index]}页面',
              style: const TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFirstPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Styles.themeStartColor,
                      Styles.themeStartColor,
                      Styles.themeEndColor,
                    ],
                    stops: const [0.0, 0.9, 1.0],
                  ),
                ),
                height: 300,
                child: Center(
                  child: HexagonIndicatorWidget(
                    size: 280.w, // 六边形整体尺寸（适配屏幕宽度）
                  ),
                ),
              ),
              Positioned(
                top: 260,
                left: 10.w,
                right: 10.w,
                child: _buildAnalysisService(),
              ),
            ],
          ),
          const SizedBox(height: 70),
          _buildServiceData(),
          const SizedBox(height: 10),
          _buildLineChart(),
          const SizedBox(height: 10),
          _buildFixedColumnTable(),
        ],
      ),
    );
  }

  Widget _buildAnalysisService() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "服务能力解读",
                    style: TextStyle(
                      color: Styles.mainFontColor,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.help_outline,
                    color: Styles.chevronRightIconColor,
                    size: 14.sp,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    "详细解读",
                    style: TextStyle(
                      color: Styles.chevronRightIconColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: Styles.chevronRightIconColor,
                    size: 14.sp,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "您的服务能力有待提高，当日每日答题数量上限为40题",
            style: TextStyle(
              color: Styles.chevronRightIconColor,
              fontSize: 12.sp,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            decoration: BoxDecoration(
              color: Color(0xFFf7f8fe),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "今日抢单题量上线",
                  style: TextStyle(fontSize: 12.sp, color: Styles.bluFontColor),
                ),
                const Spacer(),
                Text(
                  "40题",
                  style: TextStyle(fontSize: 12.sp, color: Styles.bluFontColor),
                ),
                Icon(Icons.expand_more, color: Styles.bellColor, size: 14.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceData() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "服务数据",
                  style: TextStyle(
                    color: Styles.mainFontColor,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.help_outline,
                  color: Styles.chevronRightIconColor,
                  size: 14.sp,
                ),
                const Spacer(),
                ...List.generate(serviceDataTitles.length, (index) {
                  bool isSelected = index == selectedServiceDataIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedServiceDataIndex = index;
                      });
                    },
                    child: _buildServiceDataTitle(
                      title: serviceDataTitles[index],
                      isSelected: isSelected,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDataTitle({
    required String title,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isSelected ? 14.sp : 12.sp,
          color: isSelected ? Styles.themeStartColor : Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildFixedColumnTable() {
    final sortedDates = _analysisDataMap.keys.toList()
      ..sort(
        (a, b) => DateFormat(
          'yyyy.MM.dd',
        ).parse(a).compareTo(DateFormat('yyyy.MM.dd').parse(b)),
      );
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10.w),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "明细数据",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey[200]!),
                      ),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedDates.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildTableHeaderCell(_tableHeaders[0]);
                        }
                        return _buildTableDataCell(
                          sortedDates[index - 1],
                          isFixed: true,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: (_tableHeaders.length - 1) * 80,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sortedDates.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Row(
                                children: _tableHeaders
                                    .sublist(1)
                                    .map(
                                      (header) => Expanded(
                                        child: _buildTableHeaderCell(header),
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                            final date = sortedDates[index - 1];
                            final data = _analysisDataMap[date]!;
                            return Row(
                              children: [
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.orderCount.toString(),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.responseRate.toString(),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.positiveRate.toString(),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.negativeRate.toString(),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.repeatCount.toString(),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.noLimitOrderCount.toString(),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.resolveRate.toString(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 表格头单元格
  Widget _buildTableHeaderCell(String text) {
    return Container(
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 表格数据单元格
  Widget _buildTableDataCell(String text, {bool isFixed = false}) {
    return Container(
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.black54),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 3. 构建多维度折线图（以订单数、复购数、解决率为例）
  Widget _buildLineChart() {
    final sortedDates = _analysisDataMap.keys.toList()
      ..sort(
        (a, b) => DateFormat(
          'yyyy.MM.dd',
        ).parse(a).compareTo(DateFormat('yyyy.MM.dd').parse(b)),
      );
    final orderCountSpots = sortedDates.asMap().entries.map((entry) {
      final index = entry.key;
      final data = _analysisDataMap[entry.value]!;
      return FlSpot(index.toDouble(), data.orderCount.toDouble());
    }).toList();
    final repeatCountSpots = sortedDates.asMap().entries.map((entry) {
      final index = entry.key;
      final data = _analysisDataMap[entry.value]!;
      return FlSpot(index.toDouble(), data.repeatCount.toDouble());
    }).toList();

    final resolveRateSpots = sortedDates.asMap().entries.map((entry) {
      final index = entry.key;
      final data = _analysisDataMap[entry.value]!;
      return FlSpot(index.toDouble(), data.resolveRate.toDouble());
    }).toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "趋势分析",
                  style: TextStyle(
                    color: Styles.mainFontColor,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.help_outline,
                  color: Styles.chevronRightIconColor,
                  size: 14.sp,
                ),
                const Spacer(),
                ...List.generate(trendTitles.length, (index) {
                  bool isSelected = index == trendIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        trendIndex = index;
                      });
                    },
                    child: _buildServiceDataTitle(
                      title: trendTitles[index],
                      isSelected: isSelected,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 10,),
            _buildAdvancedHorizontalList2(),
            const SizedBox(height:10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[100]!, blurRadius: 4),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true, drawVerticalLine: true),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 &&
                                index < sortedDates.length &&
                                index % 5 == 0) {
                              return Text(
                                sortedDates[index]
                                    .split('.')
                                    .sublist(1)
                                    .join('.'), // 简化显示：12.12
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    minX: 0,
                    maxX: (sortedDates.length - 1).toDouble(),
                    minY: 0,
                    maxY: 200,
                    // 适配订单数最大值
                    lineBarsData: [
                      LineChartBarData(
                        spots: orderCountSpots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // 复购数折线
                      LineChartBarData(
                        spots: repeatCountSpots,
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 2,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // 解决率折线（缩放适配Y轴）
                      LineChartBarData(
                        spots: resolveRateSpots
                            .map((e) => FlSpot(e.x, e.y * 2))
                            .toList(),
                        // 放大2倍便于显示
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 2,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedHorizontalList2() {
    return Container(
      height: 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        itemCount: filterTitles.length,
        itemBuilder: (context, index) {
          bool isSelected = index == filterIndex;
          return _buildCustomButton(
            title: filterTitles[index],
            isSelected: isSelected,
            onTap: () => setState(() => selectedIndex = index),
          );
        },
      ),
    );
  }

  Widget _buildCustomButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 6),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 6),
          backgroundColor: isSelected ? Colors.white : Colors.white,
          foregroundColor: isSelected ? Color(0xFF3b6ffb) : Color(0xFF525252),
          side: BorderSide(
            color: isSelected ? Color(0xFF486fdf) : Color(0xFFE0E0E0),
            width: 0.5,
          ),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r), // 圆角
          ),
        ),
        child: Text(title, style: TextStyle(fontSize: 12.sp)),
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final int layerCount;
  final double maxRadius;
  final Color borderColor;

  HexagonPainter({
    required this.layerCount,
    required this.maxRadius,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w
      ..isAntiAlias = true;

    for (int i = 0; i < layerCount; i++) {
      double radius = maxRadius * (i + 1) / layerCount;
      Path path = _getHexagonPath(center, radius);
      canvas.drawPath(path, paint);
    }
  }

  Path _getHexagonPath(Offset center, double radius) {
    Path path = Path();
    for (int i = 0; i < 6; i++) {
      double angle = 60 * i * pi / 180;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant HexagonPainter oldDelegate) {
    return layerCount != oldDelegate.layerCount ||
        maxRadius != oldDelegate.maxRadius ||
        borderColor != oldDelegate.borderColor;
  }
}

class HexagonIndicatorWidget extends StatelessWidget {
  // 6个指标配置：图标 + 文字
  final List<Map<String, dynamic>> indicators = [
    {'icon': Icons.text_fields_outlined, 'text': '内容质量'},
    {'icon': Icons.speed_outlined, 'text': '响应速度'},
    {'icon': Icons.edit_note_outlined, 'text': '原创表现'},
    {'icon': Icons.feedback_outlined, 'text': '用户反馈'},
    {'icon': Icons.miscellaneous_services_outlined, 'text': '服务表现'},
    {'icon': Icons.shopping_cart_outlined, 'text': '复购表现'},
  ];
  final double size; // 六边形整体尺寸
  HexagonIndicatorWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final maxRadius = size / 2 - 20.w;
    final center = size / 2;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: HexagonPainter(
              layerCount: 6,
              maxRadius: maxRadius,
              borderColor: Styles.hexagonBorderColor,
            ),
          ),
          // 2. 绘制6个顶点的指标（图标+文字）
          ...List.generate(6, (index) {
            double angle = 60 * index * pi / 180;
            double x = center + maxRadius * cos(angle);
            double y = center + maxRadius * sin(angle);

            // 调整文字和图标的位置（根据顶点方向）
            Alignment align = Alignment.center;
            if (index == 0) align = Alignment.topCenter; // 上
            if (index == 1) align = Alignment.topRight; // 右上
            if (index == 2) align = Alignment.bottomRight; // 右下
            if (index == 3) align = Alignment.bottomCenter; // 下
            if (index == 4) align = Alignment.bottomLeft; // 左下
            if (index == 5) align = Alignment.topLeft; // 左上

            return Positioned(
              left: x - 40.w,
              top: y - 20.h,
              child: Align(
                alignment: align,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 指标图标
                    Icon(
                      indicators[index]['icon'],
                      color: Styles.mainFontColor,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    // 指标文字
                    Text(
                      indicators[index]['text'],
                      style: TextStyle(
                        color: Styles.mainFontColor,
                        fontSize: 12.sp,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Text(
            '待评估',
            style: TextStyle(
              color: Styles.mainFontColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
