import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/widgets/main_appbar.dart';
import 'package:quest_app/page/widgets/svg_button.dart';
import 'package:quest_app/provider/analysis_state.dart';
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
  final String date;

  AnalysisData(
    this.orderCount,
    this.responseRate,
    this.positiveRate,
    this.negativeRate,
    this.repeatCount,
    this.noLimitOrderCount,
    this.resolveRate,
    this.date,
  );

  AnalysisData copyWith({
    int? orderCount,
    int? responseRate,
    int? positiveRate,
    int? negativeRate,
    int? repeatCount,
    int? noLimitOrderCount,
    int? resolveRate,
    String? date,
  }) {
    return AnalysisData(
      orderCount ?? this.orderCount,
      responseRate ?? this.responseRate,
      positiveRate ?? this.positiveRate,
      negativeRate ?? this.negativeRate,
      repeatCount ?? this.repeatCount,
      noLimitOrderCount ?? this.noLimitOrderCount,
      resolveRate ?? this.resolveRate,
      date ?? this.date,
    );
  }
}

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  int selectedIndex = 0;
  int selectedServiceDataIndex = 0;
  int trendIndex = 0;
  int filterIndex = 0;
  final List<String> _tableHeaders = [
    '日期',
    '订单量',
    '5分钟响应率',
    '复购数',
    '好评数',
    '差评数',
    '解决率',
  ];
  final List<String> filterTitles = [
    '订单量',
    '5分钟响应率',
    '复购数',
    '好评数',
    '差评数',
    '解决率',
  ];
  final List<String> tabTitles = ['服务分析', '商品分析', '收益分析'];
  final List<String> serviceDataTitles = ['今日', '近7天', '近30天'];
  final List<String> trendTitles = ['近7天', '近30天'];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          children: [_buildAdvancedHorizontalList(), _buildPageView(context)],
        ),
      ),
    );
  }

  Widget _buildAdvancedHorizontalList() {
    return Container(
      height: 32,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.black : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
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

  Widget _buildPageView(BuildContext context) {
    final List<AnalysisData> analysisData = context.select(
      (AnalysisState r) => r.analyses,
    );
    final List<ServiceDataInfo> serviceData = context.select(
      (AnalysisState r) => r.serviceData,
    );
    final int quoteOrderLimit = context.select(
      (AnalysisState r) => r.quoteOrderLimit,
    );
    final Map<String, int> hexagonData = context.select(
      (AnalysisState r) => r.hexagonData,
    );
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
            return _buildFirstPage(
              analysisData,
              serviceData,
              quoteOrderLimit,
              hexagonData,
            );
          } else if (index == 2) {
            return _buildIncomeAnalysisPage();
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

  Widget _buildFirstPage(
    List<AnalysisData> analysisData,
    List<ServiceDataInfo> serviceData,
    int quoteOrderLimit,
    Map<String, int> hexagonData,
  ) {
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
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: HexagonIndicatorWidget(
                      size: 200,
                      hexagonMap: hexagonData,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10.w,
                child: TextButton(
                  onPressed: () {
                    print('按钮被点击');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r), // 圆角
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: SvgIconButton(
                          assetName: "assets/svg/exchange.svg",
                          onPressed: () {},
                          color:  Styles.themeStartColor,
                          iconSize: 8.sp,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text('近30天对比', style: TextStyle(fontSize: 12.sp)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 260,
                left: 10.w,
                right: 10.w,
                child: _buildAnalysisService(quoteOrderLimit),
              ),
            ],
          ),
          const SizedBox(height: 70),
          _buildServiceData(serviceData),
          const SizedBox(height: 10),
          _buildLineChart(analysisData),
          const SizedBox(height: 10),
          _buildFixedColumnTable(analysisData),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildAnalysisService(int quoteOrderLimit) {
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
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
            "您的服务能力有待提高，当日每日答题数量上限为$quoteOrderLimit题",
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
                  "$quoteOrderLimit题",
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

  Widget _buildServiceData(List<ServiceDataInfo> serviceData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 200,
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                      setState(() {});
                    },
                    child: _buildServiceDataTitle(
                      title: serviceDataTitles[index],
                      isSelected: isSelected,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(top: 0),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.3,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _buildServiceDataItem(serviceData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDataItem(ServiceDataInfo serviceData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          serviceData.title,
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: serviceData.data.toString(),
                style: TextStyle(
                  fontSize: 20.sp,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  color: Styles.mainFontColor,
                ),
              ),
            ],
          ),
        ),
        Text(
          "昨日：${serviceData.lateDayData}",
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
      ],
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

  Widget _buildFixedColumnTable(List<AnalysisData> analysisData) {
    const dateFormatPattern = 'yyyy.MM.dd';
    final dateFormat = DateFormat(dateFormatPattern);
    if (trendIndex == 0) {
      //如果是近7天数据
      analysisData = analysisData.sublist(0, 7);
    }
    final sortedDates = analysisData.map((AnalysisData i) => i.date).toList()
      ..sort((a, b) => dateFormat.parse(a).compareTo(dateFormat.parse(b)));
    const double headerHeight = 20.0; // 标题高度
    const double rowHeight = 20.0; // 每行数据高度
    const double paddingHeight = 20.0; // 上下内边距
    const double titleHeight = 30.0; // "明细数据"标题高度
    final double tableHeight =
        titleHeight +
        headerHeight +
        (sortedDates.length * rowHeight) +
        paddingHeight +
        10;
    final double finalHeight = tableHeight.clamp(200.0, 600.0);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: finalHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: Text(
                "明细数据",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
                          return _buildTableHeaderCell(
                            _tableHeaders[0],
                            titleHeight,
                          );
                        }
                        return _buildTableDataCell(
                          sortedDates[index - 1],
                          rowHeight,
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
                                        child: _buildTableHeaderCell(
                                          header,
                                          titleHeight,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                            final date = sortedDates[index - 1];
                            final data = analysisData.firstWhere(
                              (i) => i.date == date,
                            );
                            return Row(
                              children: [
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.orderCount.toString(),
                                    rowHeight,
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.responseRate.toString(),
                                    rowHeight,
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.positiveRate.toString(),
                                    rowHeight,
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.negativeRate.toString(),
                                    rowHeight,
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.repeatCount.toString(),
                                    rowHeight,
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.noLimitOrderCount.toString(),
                                    rowHeight,
                                  ),
                                ),
                                Expanded(
                                  child: _buildTableDataCell(
                                    data.resolveRate.toString(),
                                    rowHeight,
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
  Widget _buildTableHeaderCell(String text, double height) {
    return Container(
      height: height,
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
  Widget _buildTableDataCell(
    String text,
    double height, {
    bool isFixed = false,
  }) {
    return Container(
      height: height,
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

  final Map<int, double Function(AnalysisData)> trendValueGetter = {
    0: (data) => data.orderCount.toDouble(),
    1: (data) => data.responseRate.toDouble(),
    2: (data) => data.repeatCount.toDouble(),
    3: (data) => data.positiveRate.toDouble(),
    4: (data) => data.negativeRate.toDouble(),
    5: (data) => data.resolveRate.toDouble(),
  };

  (double minValue, double maxValue) getMinMaxByTrendIndex(
    List<AnalysisData> analysisData,
    int trendIndex,
  ) {
    // 空数据兜底
    if (analysisData.isEmpty) {
      return (0.0, 0.0);
    }
    final valueGetter = trendValueGetter[trendIndex];
    if (valueGetter == null) {
      throw ArgumentError('无效的趋势索引: $trendIndex，仅支持0-5');
    }
    final values = analysisData.map((data) => valueGetter(data)).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return (minValue, maxValue);
  }

  Widget _buildLineChart(List<AnalysisData> analysisData) {
    if (trendIndex == 0) {
      analysisData = analysisData.sublist(0, 7);
    }
    const dateFormatPattern = 'yyyy.MM.dd';
    final dateFormat = DateFormat(dateFormatPattern);
    final sortedDates = analysisData.map((AnalysisData i) => i.date).toList()
      ..sort((a, b) => dateFormat.parse(a).compareTo(dateFormat.parse(b)));
    final sortedData = List<AnalysisData>.from(analysisData)
      ..sort(
        (a, b) => dateFormat.parse(a.date).compareTo(dateFormat.parse(b.date)),
      );
    final (minValue, maxValue) = getMinMaxByTrendIndex(
      analysisData,
      filterIndex,
    );
    final resolveRateSpots = sortedData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final valueGetter = trendValueGetter[filterIndex];
      if (valueGetter == null) {
        return FlSpot(index.toDouble(), 0.0);
      }
      return FlSpot(index.toDouble(), valueGetter(data));
    }).toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 300,
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
            const SizedBox(height: 10),
            _buildAdvancedHorizontalList2(),
            const SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.white),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      getTooltipColor: (touchedBarSpots) {
                        return Colors.black54.withOpacity(0.9);
                      },
                      tooltipBorderRadius: BorderRadius.circular(8),
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((spot) {
                          final dateIndex = spot.x.toInt();
                          final date = sortedDates[dateIndex];
                          final dateStr = date.split('.').sublist(1).join('');
                          String valueName;
                          double value;
                          switch (filterIndex) {
                            case 0:
                              valueName = '订单量';
                              value = analysisData
                                  .firstWhere((d) => d.date == date)
                                  .orderCount
                                  .toDouble();
                              break;
                            case 1:
                              valueName = '5分钟响应率';
                              value = analysisData
                                  .firstWhere((d) => d.date == date)
                                  .responseRate
                                  .toDouble();
                              break;
                            case 2:
                              valueName = '复购数';
                              value = analysisData
                                  .firstWhere((d) => d.date == date)
                                  .repeatCount
                                  .toDouble();
                              break;
                            case 3:
                              valueName = '好评数';
                              value = analysisData
                                  .firstWhere((d) => d.date == date)
                                  .positiveRate
                                  .toDouble();
                              break;
                            case 4:
                              valueName = '差评数';
                              value = analysisData
                                  .firstWhere((d) => d.date == date)
                                  .negativeRate
                                  .toDouble();
                              break;
                            case 4:
                              valueName = '解决率';
                              value = analysisData
                                  .firstWhere((d) => d.date == date)
                                  .resolveRate
                                  .toDouble();
                              break;
                            default:
                              valueName = '数值';
                              value = spot.y;
                          }
                          return LineTooltipItem(
                            '',
                            textAlign: TextAlign.left,
                            TextStyle(),
                            children: [
                              TextSpan(
                                text: '$dateStr\n',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: '●',
                                style: TextStyle(
                                  color: Color(0xFF3457ce), // 圆点颜色
                                  fontSize: 20.sp, // 圆点大小
                                ),
                              ),
                              TextSpan(
                                text: '$valueName：${value.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
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
                        reservedSize: 20,
                        interval: trendIndex == 0 ? 1 : 4,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= sortedDates.length) {
                            return SizedBox.shrink();
                          }
                          return Text(
                            sortedDates[index].split('.').sublist(1).join(''),
                            style: TextStyle(fontSize: 10.sp),
                          );
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
                    border: Border(
                      left: BorderSide(color: Colors.grey[200]!), // 显示左边框
                      bottom: BorderSide(color: Colors.grey[200]!), // 显示下边框
                      top: BorderSide.none, // 隐藏上边框
                      right: BorderSide.none, // 隐藏右边框
                    ),
                  ),
                  minX: -1,
                  maxX: (sortedDates.length).toDouble(),
                  minY: minValue,
                  maxY: maxValue,
                  lineBarsData: [
                    LineChartBarData(
                      spots: resolveRateSpots
                          .map((e) => FlSpot(e.x, e.y))
                          .toList(),
                      isCurved: false,
                      color: Color(0xFF3457ce),
                      barWidth: 1,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 2,
                            color: Color(0xFF3457ce),
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedHorizontalList2() {
    return SizedBox(
      height: 25,
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
            onTap: () => setState(() => filterIndex = index),
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

  Widget _buildIncomeAnalysisPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                color: Color(0xFFf7f8fe),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/17.png", width: 12, height: 12),
                  const SizedBox(width: 4),
                  Text(
                    "答主收益说明",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 12.sp,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage("assets/images/bg2.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "本月税前收益",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFFc0dcff),
                          ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: Icon(
                              Icons.help_outline,
                              size: 14.sp,
                              color: Color(0xFFc0dcff),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "0.00",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center, // 设置文本居中
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "可提现余额(元)",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xFFc0dcff),
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Icon(
                                  Icons.help_outline,
                                  size: 14.sp,
                                  color: Color(0xFFc0dcff),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "0.00",
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        "打款明细",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Color(0xFFc0dcff),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF3f6ff4),
                          side: BorderSide(
                            color: Color(0xFF3f6ff4).withOpacity(0.1), // 边框颜色
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r), // 圆角
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2.h,
                          ),
                        ),
                        child: Text(
                          '立即提现',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Divider(height: 1, color: Color(0xFFc0dcff).withOpacity(0.1)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 10.sp,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        "提现后百度将为您申报个税，可在个税APP查询",
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        "反馈",
                        style: TextStyle(fontSize: 10.sp, color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 10.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final int layerCount;
  final double maxRadius;
  final Color borderColor;
  final Map<String, int> hexagonMap;
  final Map<int, String> indicatorTitles;

  HexagonPainter({
    required this.layerCount,
    required this.maxRadius,
    required this.borderColor,
    required this.hexagonMap,
    required this.indicatorTitles,
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
      Path hexagonPath = _getRotatedHexagonPath(center, radius);
      canvas.drawPath(hexagonPath, paint);
      _drawRadiantLines(canvas, center, radius, paint);
    }

    _drawDataArea(canvas, center);
  }

  Path _getRotatedHexagonPath(Offset center, double radius) {
    Path path = Path();
    for (int i = 0; i < 6; i++) {
      double angle = ((60 * i) + 90) * pi / 180; // cons(Π/3) = 1 / 2
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

  void _drawRadiantLines(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    for (int i = 0; i < 6; i++) {
      double angle = ((60 * i) + 90) * pi / 180;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  void _drawDataArea(Canvas canvas, Offset center) {
    Path dataPath = Path();
    List<Offset> dataPoints = [];

    // 计算每个指标的位置点
    for (int i = 0; i < 6; i++) {
      String title = indicatorTitles[i]!;
      int score = hexagonMap[title] ?? 0;

      // 确保分数在 0-100 范围内
      score = score.clamp(0, 100);

      // 计算该点在轴线上的位置（根据分数占比）
      double ratio = score / 100.0;
      double radius = maxRadius * ratio;

      double angle = ((60 * i) + 90) * pi / 180;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);

      Offset point = Offset(x, y);
      dataPoints.add(point);

      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF69c8f8).withOpacity(1), // 顶部颜色
        Color(0xFF69c8f8).withOpacity(0.3), //底部颜色
      ],
      stops: [0.0, 1.0],
    );

    final rect = Rect.fromCircle(center: center, radius: maxRadius);

    // 填充渐变色
    final fillPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(dataPath, fillPaint);

    // 绘制数据区域边框
    final borderPaint = Paint()
      ..color = Color(0xFF7ec3fe)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w
      ..isAntiAlias = true;

    canvas.drawPath(dataPath, borderPaint);

    // final pointPaint = Paint()
    //   ..color = Color(0xFF4A90E2)
    //   ..style = PaintingStyle.fill
    //   ..isAntiAlias = true;

    // for (Offset point in dataPoints) {
    //   canvas.drawCircle(point, 4.w, pointPaint);
    //
    //   final pointBorderPaint = Paint()
    //     ..color = Colors.white
    //     ..style = PaintingStyle.stroke
    //     .. strokeWidth = 1.5.w
    //     ..isAntiAlias = true;
    //
    //   canvas.drawCircle(point, 4.w, pointBorderPaint);
    // }
  }

  @override
  bool shouldRepaint(covariant HexagonPainter oldDelegate) {
    return layerCount != oldDelegate.layerCount ||
        maxRadius != oldDelegate.maxRadius ||
        borderColor != oldDelegate.borderColor;
  }
}

class HexagonIndicatorWidget extends StatelessWidget {
  final List<Map<String, dynamic>> indicators = [
    {'icon': Icons.text_fields_outlined, 'text': '内容质量'},
    {'icon': Icons.speed_outlined, 'text': '响应速度'},
    {'icon': Icons.edit_note_outlined, 'text': '原创表现'},
    {'icon': Icons.feedback_outlined, 'text': '用户反馈'},
    {'icon': Icons.miscellaneous_services_outlined, 'text': '服务表现'},
    {'icon': Icons.shopping_cart_outlined, 'text': '复购表现'},
  ];
  final double size;
  final Map<String, int> hexagonMap;
  final Map<int, String> indicatorTitles = {
    0: "用户反馈",
    1: "服务表现",
    2: "复购表现",
    3: "内容质量",
    4: "响应速度",
    5: "原创表现",
  };

  HexagonIndicatorWidget({
    super.key,
    required this.size,
    required this.hexagonMap,
  });

  @override
  Widget build(BuildContext context) {
    int sum = 0;
    hexagonMap.forEach((key, value) {
      sum += value;
    });
    final int totalAbilityCount = (sum / 600 * 100).toInt();
    final center = size / 2;
    final maxRadius = size / 2;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size * 0.6, size * 0.6),
            painter: HexagonPainter(
              layerCount: 6,
              maxRadius: size * 0.6 / 2,
              borderColor: Styles.hexagonBorderColor,
              hexagonMap: hexagonMap,
              indicatorTitles: indicatorTitles,
            ),
          ),

          ...List.generate(6, (index) {
            double angle = ((60 * index) + 90) * pi / 180;
            double x = center + maxRadius * cos(angle);
            double y = center + maxRadius * sin(angle);
            Alignment align = Alignment.center;
            if (index == 0) y = y - 40;
            if (index == 1) y = y - 30;
            if (index == 2) align = Alignment.center; // 右下
            if (index == 3) align = Alignment.center; // 下
            if (index == 4) align = Alignment.center; // 下
            if (index == 5) y = y - 30;
            return Positioned(
              left: x - 35,
              top: y,
              child: Container(
                width: 70,
                height: 40,
                // decoration: BoxDecoration(
                //   border: Border.all(width: 1, color: Colors.white),
                // ),
                child: Column(
                  children: [
                    Text(
                      hexagonMap[indicatorTitles[index]!].toString(),
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          indicators[index]['icon'],
                          color: Colors.white,
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          indicatorTitles[index]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$totalAbilityCount\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '总能力分',
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
