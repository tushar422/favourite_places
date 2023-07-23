import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/model/place.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  //crud

  void createPlace(Place place) {
    state = [place, ...state];
  }

  void deletePlace(Place place) {
    state = state.where((element) => element.id != place.id).toList();
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
