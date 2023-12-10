import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

import '../utils/utils.dart';

class WaterFavoritesPage extends StatefulWidget {
  const WaterFavoritesPage({super.key});

  @override
  State<WaterFavoritesPage> createState() => _WaterFavoritesPageState();
}

class _WaterFavoritesPageState extends State<WaterFavoritesPage> {
  // 定义主题颜色
  final machineIDController = TextEditingController();
  final machineDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    machineIDController.clear();
    machineDescriptionController.clear();
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("确认删除"),
          content: Text("您确定要删除吗？"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("确定"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("取消"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: Storage.waterDispensers.length,
          itemBuilder: (context, index) {
            var waterDispenser = Storage.waterDispensers[index];
            return Dismissible(
              key: Key(waterDispenser.machineID),
              confirmDismiss: (direction) async {
                // 显示确认对话框
                bool confirm = await showDeleteConfirmationDialog(context);
                return confirm;
              },
              onDismissed: (direction) {
                setState(() {
                  Storage.removeWaterDispenser(waterDispenser.machineID);
                });
              },
              background: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.delete,
                  ),
                ),
              ),
              direction: DismissDirection.startToEnd,
              // 限制只能水平滑动
              // 修改滑动触发阈值
              dismissThresholds: {
                DismissDirection.endToStart: 0.7,
                DismissDirection.startToEnd: 0.7,
              },
              child: Container(
                margin: EdgeInsets.all(8),
                child: Material(
                  borderRadius: BorderRadius.circular(8), // 圆角设置
                  elevation: 4, // 阴影设置
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: Card(
                      shape: CircleBorder(),
                      elevation: 4, // 添加阴影
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: Text(
                            waterDispenser.machineID.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      waterDispenser.description,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (await Haptics.canVibrate() == true) {
                              await Haptics.vibrate(HapticsType.success);
                            }
                            quickStart(waterDispenser.machineID);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: Icon(
                              Icons.play_arrow,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 16), // 添加间隔
                        ElevatedButton(
                          onPressed: () async {
                            if (await Haptics.canVibrate() == true) {
                              await Haptics.vibrate(HapticsType.error);
                            }
                            quickStop(waterDispenser.machineID);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: Icon(
                              Icons.stop,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('添加饮水机'),
                  content: SizedBox(
                    height: 150,
                    child: Column(
                      children: [
                        TextField(
                          controller: machineIDController,
                          decoration: InputDecoration(
                            labelText: '饮水机号',
                          ),
                        ),
                        TextField(
                          controller: machineDescriptionController,
                          decoration: InputDecoration(
                            labelText: '饮水机描述',
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        if (await Storage.addWaterDispenser(
                              machineIDController.text,
                              machineDescriptionController.text,
                            ) ==
                            true) {
                          // 弹出toast提示添加成功并刷新页面
                          showToast('添加成功');
                          setState(() {});
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        } else {
                          showToast('添加失败');
                        }
                      },
                      child: Text('确定'),
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
