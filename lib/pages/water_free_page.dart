import 'package:flutter/material.dart';

import '../utils/utils.dart';

class WaterFreePage extends StatefulWidget {
  const WaterFreePage({super.key});

  @override
  State<WaterFreePage> createState() => _WaterFreePageState();
}

class _WaterFreePageState extends State<WaterFreePage> {
  final cardNumController = TextEditingController(text: Storage.cardNum ?? '');

  @override
  void dispose() {
    cardNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cardNumController,
              decoration: InputDecoration(
                labelText: '卡号',
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Storage.cardNum = cardNumController.text;
                  },
                  icon: Icon(Icons.save),
                  label: Text('保存卡号'),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.question_mark),
                  label: Text('如何获取卡号？'),
                  onPressed: () {
                    // 弹窗显示两张图片(guide1和guide2)，用于告诉用户如何获取卡号
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('如何获取卡号？'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/images/guide1.jpg',
                                    height: 220,
                                  ),
                                  Image.asset(
                                    'assets/images/guide2.jpg',
                                    height: 220,
                                  ),
                                ],
                              )
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('知道了'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
