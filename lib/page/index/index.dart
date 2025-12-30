import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '欢迎来到首页',
              style: TextStyle(fontSize: 24, fontWeight:  FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:  () {
              },
              child: const Text('开始使用'),
            ),
          ],
        ),
      ),
    );
  }
}