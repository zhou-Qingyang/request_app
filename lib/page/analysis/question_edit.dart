import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/provider/analysis_state.dart';

import '../../model/question.dart';

class QuestionListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '问题列表管理',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: IconButton(
                onPressed: () => _showQuestionDialog(context),
                icon: Icon(Icons.add_circle, size: 28.sp),
                color: Color(0xFF4f6de4),
                tooltip: '新增问题',
              ),
            ),
        ],
      ),
      body: Consumer<AnalysisState>(
        builder: (context, provider, child) {
          if (provider.questions. isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment. center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size:  80.sp,
                    color: Color(0xFFBDBDBD),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '暂无数据',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: provider.questions.length,
            itemBuilder: (context, index) {
              final question = provider.questions[index];
              return _buildQuestionCard(context, question);
            },
          );
        },
      ),
    );
  }

  // 构建问题卡片
  Widget _buildQuestionCard(BuildContext context, QuestionInfo question) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors. black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和操作按钮
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
              ),
            ),
            child: Row(
              children:  [
                Expanded(
                  child: Text(
                    question.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                // 状态标签
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color:  Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    question.status,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 详细信息
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.access_time,
                        label:  '接单时间',
                        value: question.acceptTime,
                        iconColor: Color(0xFF4f6de4),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.schedule,
                        label: '预计打款',
                        value: question.expectedPaymentTime,
                        iconColor: Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child:  _buildInfoItem(
                        icon: Icons.comment,
                        label: '原因',
                        value: question.reason,
                        iconColor: Color(0xFF9C27B0),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.attach_money,
                        label:  '支付金额',
                        value: '¥${question.paymentAmount.toStringAsFixed(2)}',
                        iconColor: Color(0xFFFF5722),
                        valueColor: Color(0xFFFF5722),
                        valueBold: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 操作按钮
          Container(
            padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton. icon(
                  onPressed:  () => _showQuestionDialog(context, question: question),
                  icon: Icon(Icons.edit_outlined, size: 16.sp),
                  label: Text('编辑'),
                  style:  TextButton.styleFrom(
                    foregroundColor: Color(0xFF4f6de4),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
                SizedBox(width: 8.w),
                TextButton.icon(
                  onPressed: () => _confirmDelete(context, question),
                  icon: Icon(Icons.delete_outline, size: 16.sp),
                  label: Text('删除'),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFF44336),
                    padding: EdgeInsets. symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建信息项
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.sp, color: iconColor),
              SizedBox(width:  4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Color(0xFF757575),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: valueColor ?? Color(0xFF333333),
              fontWeight:  valueBold ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 显示添加/编辑对话框
  void _showQuestionDialog(BuildContext context, {QuestionInfo? question}) {
    final titleController = TextEditingController(text: question?.title ?? '');
    final paymentTimeController = TextEditingController(
        text: question?.expectedPaymentTime ??  '');
    final acceptTimeController = TextEditingController(
        text: question?.acceptTime ?? '');
    final amountController = TextEditingController(
        text: question?.paymentAmount.toString() ?? '');

    showDialog(
      context:  context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            width:  500.w,
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      question == null ? Icons.add_circle_outline : Icons.edit_outlined,
                      color: Color(0xFF4f6de4),
                      size:  24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      question == null ? '添加问题' : '编辑问题',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight. bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(
                        controller:  titleController,
                        label:  '问题标题',
                        icon: Icons.title,
                        hint: '请输入问题标题',
                      ),
                      SizedBox(height: 16.h),
                      _buildTextField(
                        controller: acceptTimeController,
                        label:  '接单时间',
                        icon: Icons.access_time,
                        hint:  'YYYY-MM-DD',
                      ),
                      SizedBox(height: 16.h),
                      _buildTextField(
                        controller: paymentTimeController,
                        label:  '预计打款时间',
                        icon: Icons.schedule,
                        hint: 'YYYY-MM-DD',
                      ),
                      SizedBox(height: 16.h),
                      _buildTextField(
                        controller: amountController,
                        label: '支付金额',
                        icon: Icons.attach_money,
                        hint: '请输入金额',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // 按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text('取消'),
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF757575),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('请输入问题标题')),
                          );
                          return;
                        }

                        final newQuestion = QuestionInfo(
                          id: question?.id ??  0,
                          title:  titleController.text,
                          expectedPaymentTime: paymentTimeController. text,
                          acceptTime:  acceptTimeController.text,
                          paymentAmount: double.tryParse(amountController.text) ?? 0,
                        );

                        final provider = Provider.of<AnalysisState>(context, listen: false);
                        if (question == null) {
                          provider.addQuestion(newQuestion);
                        } else {
                          provider.updateQuestion(newQuestion);
                        }

                        Navigator.pop(dialogContext);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(question == null ? '添加成功' : '更新成功'),
                            backgroundColor: Color(0xFF4CAF50),
                          ),
                        );
                      },
                      child: Text('保存'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4f6de4),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets. symmetric(horizontal: 24.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 构建输入框
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType?  keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFF4f6de4)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Color(0xFF4f6de4), width: 2),
        ),
        filled: true,
        fillColor: Color(0xFFFAFAFA),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  // 确认删除
  void _confirmDelete(BuildContext context, QuestionInfo question) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFF44336), size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                '确认删除',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            '确定要删除 "${question.title}" 吗？此操作不可恢复。',
            style:  TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('取消'),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF757575),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<AnalysisState>(context, listen: false)
                    .deleteQuestion(question.id);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('删除成功'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF44336),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('删除'),
            ),
          ],
        );
      },
    );
  }
}