import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/accept/accept.dart';
import 'package:quest_app/page/analysis/analysis.dart';
import 'package:quest_app/page/order/order.dart';
import 'package:quest_app/page/widgets/main_appbar.dart';
import 'package:quest_app/provider/route_state.dart';

import '../../helper/style.dart';

class CenterPage extends StatefulWidget {
  const CenterPage({super.key});

  @override
  State<CenterPage> createState() => _CenterPageState();
}

class DataCenterInfo {
  final String dataKey;
  final String data;
  final String lastData;

  DataCenterInfo({
    required this.dataKey,
    required this.data,
    required this.lastData,
  });
}

class IconDataCenterInfo {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  IconDataCenterInfo(this.iconPath, this.title, this.onTap);
}

class _CenterPageState extends State<CenterPage> {
  late List<DataCenterInfo> datas;
  late List<IconDataCenterInfo> iconData;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> images = [
    "https://picsum.photos/1920/1080",
    "https://picsum.photos/1920/1080",
    "https://picsum.photos/1920/1080",
    "https://picsum.photos/1920/1080",
  ];

  late PageController _bannerPageController = PageController();
  int _currentBannerPage = 0;
  Timer? _bannerTimer;

  void _startAutoScroll() {
    _bannerTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentBannerPage < images.length - 1) {
        _currentBannerPage++;
      } else {
        _currentBannerPage = 0;
      }
      if (_bannerPageController.hasClients) {
        _bannerPageController.animateToPage(
          _currentBannerPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    datas = [
      DataCenterInfo(dataKey: '能力分', data: '待评估', lastData: '昨日 --'),
      DataCenterInfo(dataKey: '本月税前收益', data: '0.00', lastData: '上月  0.00'),
      DataCenterInfo(dataKey: '成长值', data: '0', lastData: '本周  0'),
    ];

    iconData = [
      IconDataCenterInfo("assets/images/gpt.png", "情感星球", () {}),
      IconDataCenterInfo("assets/images/gpt.png", "数据分析", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Analysis()),
        );
      }),
      IconDataCenterInfo("assets/images/gpt.png", "咨询抢单", () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AcceptPage()),
        // );
        context.read<RouterState>().changeIndex(1);
      }),
      IconDataCenterInfo("assets/images/gpt.png", "订单管理", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderPage()),
        );
      }),
      IconDataCenterInfo("assets/images/gpt.png", "成长中心", () {}),
      IconDataCenterInfo("assets/images/gpt.png", "问币商城", () {}),
      IconDataCenterInfo("assets/images/gpt.png", "我的周报", () {}),
      IconDataCenterInfo("assets/images/gpt.png", "答主学院", () {}),
      IconDataCenterInfo("assets/images/gpt.png", "我的主页", () {}),
      IconDataCenterInfo("assets/images/gpt.png", "应用中心", () {}),

      IconDataCenterInfo("assets/images/gpt.png", "我的周报", () {}),
      IconDataCenterInfo("assets/images/gpt.png", "答主学院", () {}),
      IconDataCenterInfo("assets/images/gpt.png", "我的主页", () {}),
      IconDataCenterInfo("assets/images/gpt.png", "应用中心", () {}),
    ];
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = MediaQuery.of(context).padding.top + 42.h;
    return Scaffold(
      backgroundColor: Styles.mainBackground,
      extendBodyBehindAppBar: true,
      appBar: MainAppBar(
        title: Text(
          "答主中心",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: paddingHeight),
          child: Column(
            children: [
              _buildHeadDataCenter(),
              const SizedBox(height: 110), // 上面Stack超出100
              _buildBanner(),
              const SizedBox(height: 10),
              _buildOrders(),
              const SizedBox(height: 10),
              _buildClass(),
              const SizedBox(height: 10),
              SizedBox(height: 60.h), // 底部导航栏
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeadDataCenter() {
    final int itemsPerPage = 10;
    final int pageCount = (iconData.length / itemsPerPage).ceil();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Styles.themeStartColor, // 起始色（原主题色+透明度）
                Styles.themeStartColor, // 中间色（示例：浅蓝）
                Styles.themeEndColor, // 结束色（示例：深蓝）
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              datas.length,
              (index) => _buildDataItem(datas[index], index),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 10.w,
          right: 10.w,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  height: 160,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: pageCount,
                    itemBuilder: (context, pageIndex) {
                      return _buildIconGrid(pageIndex, itemsPerPage);
                    },
                  ),
                ),
                _buildPageIndicator(pageCount),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconGrid(int pageIndex, int itemsPerPage) {
    final startIndex = pageIndex * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, iconData.length);
    final pageItems = iconData.sublist(startIndex, endIndex);
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: pageItems.length,
      itemBuilder: (context, index) {
        return _buildIconItem(pageItems[index]);
      },
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    return SizedBox(
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          pageCount,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: 20.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? Styles.themeStartColor
                  : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 160.h,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _bannerPageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentBannerPage = index;
                        });
                      },
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print('点击了第 ${index + 1} 张图片');
                          },
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 0,
                      right: 0,
                      child: _buildBannerIndicator(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                color: Styles.themeEndColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "公告",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Styles.orgFontColor,
                    ),
                  ),
                  _buildDivider(),
                  Text(
                    "立即开启预约咨询功能，让接单更轻松高效!",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Styles.mainFontColor,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: Styles.chevronRightIconColor,
                    size: 14.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 12,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(color: Styles.mainFontColor.withOpacity(0.5)),
    );
  }

  Widget _buildBannerIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        images.length,
        (index) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 20.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: _currentBannerPage == index
                ? Colors.white
                : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(1.r),
          ),
        ),
      ),
    );
  }

  Widget _buildIconItem(IconDataCenterInfo item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Styles.themeStartColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                item.iconPath,
                width: 24.w,
                height: 24.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            item.title,
            style: TextStyle(fontSize: 12.sp, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(DataCenterInfo data, int index) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              data.dataKey,
              style: TextStyle(
                color: Styles.grayFontColor,
                fontSize: index == 1 ? 16.sp : 14.sp,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.help_outline,
              color: Styles.grayFontColor,
              size: index == 1 ? 14.sp : 12.sp,
            ),
          ],
        ),
        SizedBox(height: index == 1 ? 10 : 10),
        Text(
          data.data,
          style: TextStyle(
            color: Colors.white,
            fontSize: index == 1 ? 26.sp : 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: index == 1 ? 10 : 10),
        index == 1
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    data.lastData,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.help_outline,
                    color: Styles.grayFontColor,
                    size: index == 1 ? 14.sp : 12.sp,
                  ),
                ],
              )
            : Text(
                data.lastData,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
      ],
    );
  }

  Widget _buildOrders() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 120,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "待回答",
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
                        "全部订单",
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
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                color: Color(0xFFf7f8fe),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.bell_fill,
                    color: Styles.bellColor,
                    size: 14.sp,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "暂无待回答订单",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Styles.bluFontColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      print('按钮被点击');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF3f6ff4), // 文字颜色
                      side: BorderSide(
                        color: Color(0xFF3f6ff4).withOpacity(0.1), // 边框颜色
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r), // 圆角
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                    ),
                    child: Text(
                      '去抢单',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
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

  Widget _buildClass() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "课程上新",
                    style: TextStyle(
                      color: Styles.mainFontColor,
                      fontSize: 16.sp,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        "全部课程",
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
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _buildClassItem(
                  "https://picsum.photos/1920/1080",
                  "如何获得 答主标签,得到平台的认可？",
                ),
                _buildClassDivider(),
                _buildClassItem(
                  "https://picsum.photos/1920/1080",
                  "如何获得 答主标签,得到平台的认可？",
                ),
                _buildClassDivider(),
                _buildClassItem(
                  "https://picsum.photos/1920/1080",
                  "如何获得 答主标签,得到平台的认可？",
                ),
                const SizedBox(height: 10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 10.w),
      decoration: BoxDecoration(color: Styles.mainFontColor.withOpacity(0.1)),
    );
  }


  Widget _buildClassItem(String imgUrl, String title) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            imgUrl,
            width: 120.w,
            height: 80.w,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, color: Styles.mainFontColor),
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "19.0万阅读",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600]!,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print('按钮被点击');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF3f6ff4), // 文字颜色
                      side: BorderSide(
                        color: Color(0xFF3f6ff4).withOpacity(0.1), // 边框颜色
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r), // 圆角
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                    ),
                    child: Text(
                      '去学习',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
