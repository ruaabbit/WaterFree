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
  Color primaryColor = Colors.blue[300]!;
  final machineIDController = TextEditingController();
  final machineDescriptionController = TextEditingController();

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
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
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: Storage.waterDispensers.map((waterDispenser) {
          return Dismissible(
            key: Key(waterDispenser.machineID),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                // 显示确认对话框
                bool confirm = await showDeleteConfirmationDialog(context);
                return confirm;
              }
              return true;
            },
            onDismissed: (direction) {
              setState(() {
                Storage.removeWaterDispenser(waterDispenser.machineID);
              });
            },
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
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
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      waterDispenser.machineID.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
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
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Icon(
                          Icons.stop,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
