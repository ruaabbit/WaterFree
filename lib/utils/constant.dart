class WaterDispenser {
  late String region; // 校区
  late String building; // 建筑
  late String floor; // 楼层
  late String machineID; // 机器号
  late String description; // 机器描述

  // 一个用于将所有字段转变为JSON格式的方法
  Map<String, dynamic> toJson() => {
        'region': region,
        'building': building,
        'floor': floor,
        'machineID': machineID,
        'description': description,
      };

  //一个用于将JSON格式转化回字段的静态方法
  static WaterDispenser fromJson(Map<String, dynamic> json) {
    return WaterDispenser()
      ..region = json['region'] as String
      ..building = json['building'] as String
      ..floor = json['floor'] as String
      ..machineID = json['machineID'] as String
      ..description = json['description'] as String;
  }
}

// 创建一个WaterDispenser数组，用以存储所有需要硬编码存储的常量信息
List<WaterDispenser> waterDispensersConst = [
  WaterDispenser()
    ..region = '西海岸校区'
    ..building = '教学区北楼'
    ..floor = '4'
    ..machineID = '1'
    ..description = '（西海岸）教北4东冷',
  WaterDispenser()
    ..region = '南湖校区'
    ..building = '南湖一栋'
    ..floor = '1'
    ..machineID = '2'
    ..description = '南湖一栋1楼',
];
