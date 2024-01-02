import 'dart:convert';

import 'package:sembast/sembast.dart';

import '../../../../models/video_list.dart';
import '../../../../models/video_model.dart';
import '../../constants/db_constants.dart';

class ChannelDataSource {
  final _channelLocalStore = intMapStoreFactory.store(DBConstants.STORE_CHANNEL);
  final Database _db;

  ChannelDataSource(this._db);

  Future<int> insert(String channelId) async =>
      await _channelLocalStore.add(_db, {'channelId': channelId});

  Future<int> count() async => await _channelLocalStore.count(_db);

  Future<List<String>> getChannelIdsFromDb() async {
    final recordSnapshots = await _channelLocalStore.find(_db);
    if (recordSnapshots.length > 0) {
      return recordSnapshots.map((snapshot) => snapshot['channelId'] as String).toList();
    } else {
      return [];
    }
  }

  Future<int> update(String channelId) async {
    final finder = Finder(filter: Filter.equals('channelId', channelId));
    return await _channelLocalStore.update(_db, {'channelId': channelId}, finder: finder);
  }

  Future<int> delete(String channelId) async {
    final finder = Finder(filter: Filter.equals('channelId', channelId));
    return await _channelLocalStore.delete(_db, finder: finder);
  }

  Future deleteAll() async {
    await _channelLocalStore.drop(_db);
  }
}
