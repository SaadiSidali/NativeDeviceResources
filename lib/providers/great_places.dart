import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id)
  {
    return _items.firstWhere((item)=>item.id==id);
  }

  Future<void> addPlace(String title, File image, PlaceLocation location) async {
    final address = await LocationHelper.getPlaceAdress(location.latitude, location.longitude);
    final updatedLocation =
        PlaceLocation(latitude: location.latitude, longitude: location.longitude, adress: address);
    final newPlace =
        Place(image: image, title: title, id: DateTime.now().toString(), location: updatedLocation);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.adress
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                adress: item['address'],
              ),
            ))
        .toList();
    notifyListeners();
  }
}
