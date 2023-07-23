import 'package:favourite_places/model/place.dart';
import 'package:favourite_places/provider/places_provider.dart';
import 'package:favourite_places/screen/new_place.dart';
import 'package:favourite_places/widget/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  List<Place> _placesList = [];

  @override
  Widget build(BuildContext context) {
    _placesList = ref.watch(placesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPlace,
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      body: PlacesList(list: _placesList),
    );
  }

  void _addPlace() {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: '/add'),
        builder: (context) {
          return const NewPlaceScreen();
        },
      ),
    );
  }
}
