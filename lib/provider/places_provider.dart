import 'package:favourite_places/database/helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/model/place.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  //crud

  Future<void> loadPlaces() async {
    final dbHelper = DBHelper();
    state = await dbHelper.getPlaces();
  }

  void createPlace(Place place) async {
    if (place.image != null) {
      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileName = path.basename(place.image!.path);
      final copiedImage = await place.image!.copy('${appDir.path}/$fileName');
      place = Place(
          title: place.title, image: copiedImage, location: place.location);
    }
    final dbHelper = DBHelper();
    dbHelper.insertPlace(place);

    state = [
      ...state,
      place,
    ];
  }

  void deletePlace(Place place) {
    state = state.where((element) => element.id != place.id).toList();
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
