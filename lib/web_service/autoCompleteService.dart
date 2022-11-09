import 'dart:async';
import 'dart:math';

import 'package:envi/utils/utility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database/database.dart';
import '../database/favoritesData.dart';
import '../database/favoritesDataDao.dart';
import '../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';

class AutocompleteService {
  late final FavoritesDataDao dao;

  List<String> title = [];
  List<SearchPlaceModel> favPlaceList = [];

  dynamic removeDuplicate(List<FavoritesData?> listtt) async {
    if (listtt.isEmpty) {
      return;
    }
    for (var i = 0; i < listtt.length; i++) {
      for (var j = i + 1; j < listtt.length; j++) {
        if (formatAddress(listtt[i]!.address.trim()) ==
                formatAddress(listtt[j]!.address.trim()) &&
            listtt[i]!.title.trim() == listtt[j]!.title.trim()) {
          await dao.deleteTask(listtt[i]!);
        }
      }
    }
    return listtt;
  }

  Future<dynamic> getdata(String pat) async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    dao = database.taskDao;
    // homeDetail = await dao.findTaskByTitle("Home");
    // workDetail = await dao.findTaskByTitle("Work");
    // List<FavoritesData> temparr = await dao.getFavoriate();
    // if (temparr.isNotEmpty) {
    //   for (var i = 0; i < temparr.length; i++) {
    //     title.add(temparr[i].address);
    //   }
    // }

    await removeDuplicate(await dao.displayDescByAddress(pat));
    List<FavoritesData?> favData = await dao.displayDescByAddress(pat);

    if (favData.isNotEmpty) {
      for (var element in favData) {
        favPlaceList.add(SearchPlaceModel(
            id: element!.id.toString(),
            address: element.address,
            title: element.title,
            latLng: LatLng(double.parse(element.latitude),
                double.parse(element.longitude)),
            isFavourite: element.isFavourite));
        title.add(element.address);
      }
      favPlaceList.sort((a, b) =>
          a.isFavourite.toLowerCase().compareTo(b.isFavourite.toLowerCase()));
    }

    return favPlaceList;
  }

  Future<List<String>> getSuggestions(String query) async {
    List<String> matches = <String>[];

    await getdata(query);
    matches.addAll(title);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
