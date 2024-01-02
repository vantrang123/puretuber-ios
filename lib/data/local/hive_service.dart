import 'package:hive/hive.dart';

class HiveService {
  isExists({required String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  addBoxes<T>(List<T> items, String boxName) async {
    final openBox = await Hive.openBox(boxName);

    for (var item in items) {
      openBox.add(item);
    }
  }

  updateBoxes<T>(item, String boxName) async {
    final openBox = await Hive.openBox(boxName);

    for (int i = 0; i < openBox.length; i++) {
      if (openBox.getAt(i).keyword == item.keyword) {
        openBox.deleteAt(i);
        break;
      }
    }

    openBox.add(item);
  }

  getBoxes<T>(String boxName) async {
    List<T> boxList = <T>[];

    final openBox = await Hive.openBox(boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }

    return boxList;
  }

  deleteItem<T>(int index, String boxName) async {
    final openBox = await Hive.openBox(boxName);

    openBox.deleteAt(index);
  }
}
