import 'package:flutter/material.dart';

class DotProgressBar extends StatefulWidget {
  // 进度值（0.0 ~ 1.0），支持外部传入
  final double progress;
  // 进度条高度
  final double height;
  // 进度条背景色
  final Color backgroundColor;
  // 进度条已完成颜色
  final Color progressColor;
  // 圆点大小
  final double dotSize;
  // 新增：圆点左侧最小边距（距离进度条左边缘的距离）
  final double dotLeftPadding;

  DotProgressBar({
    super.key,
    this.progress = 0.0,
    this.height = 8.0,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.dotSize = 16.0,
    this.dotLeftPadding = 8.0, // 默认左间距8px
  }) : assert(progress >= 0.0 && progress <= 1.0);

  @override
  State<DotProgressBar> createState() => _DotProgressBarState();
}

class _DotProgressBarState extends State<DotProgressBar> {
  @override
  Widget build(BuildContext context) {
    // 1. 获取进度条总宽度（去除左右边距，适配父容器）
    final progressBarTotalWidth = MediaQuery.of(context).size.width;
    // 2. 计算圆点的基础左偏移（基于进度）
    double dotBaseLeft = (progressBarTotalWidth * widget.progress) - (widget.dotSize / 2);
    // 3. 限制圆点最小左偏移 = 左侧边距 - 圆点半径（确保圆点不超出左侧）
    final minDotLeft = widget.dotLeftPadding - (widget.dotSize / 2);
    // 4. 最终圆点左偏移（取基础偏移和最小偏移的最大值）
    final dotFinalLeft = dotBaseLeft.clamp(minDotLeft, progressBarTotalWidth - (widget.dotSize / 2));

    // 5. 计算进度条的有效宽度（适配圆点左侧边距，避免进度条超出视觉范围）
    final progressBarEffectiveWidth = progressBarTotalWidth - widget.dotLeftPadding;
    final progressBarActualWidth = (progressBarEffectiveWidth * widget.progress) + widget.dotLeftPadding;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Padding(
          padding: EdgeInsets.only(left: widget.dotLeftPadding),
          child: Container(
            width: progressBarTotalWidth - widget.dotLeftPadding,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
          ),
        ),
        // AnimatedContainer(
        //   duration: const Duration(milliseconds: 300),
        //   width: progressBarActualWidth,
        //   height: widget.height,
        //   margin: EdgeInsets.only(left: widget.dotLeftPadding),
        //   decoration: BoxDecoration(
        //     color: widget.progressColor,
        //     borderRadius: BorderRadius.circular(widget.height / 2),
        //   ),
        // ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: dotFinalLeft + 6,
          top: (widget.height - widget.dotSize) / 2,
          child: Container(
            width: widget.dotSize,
            height: widget.dotSize,
            decoration: BoxDecoration(
              color: Color(0xFF889cf7),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}