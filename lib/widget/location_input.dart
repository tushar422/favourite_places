

import 'package:dotted_border/dotted_border.dart';
import 'package:favourite_places/model/place.dart';
import 'package:favourite_places/screen/map.dart';
import 'package:favourite_places/util/location.dart';

import 'package:flutter/material.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelect});

  @override
  State<LocationInput> createState() => _LocationInputState();
  final void Function(PlaceLocation? location) onSelect;
}

class _LocationInputState extends State<LocationInput> {
  bool _isFetchingLocation = false;
  PlaceLocation? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_isFetchingLocation) {
      content = const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: LinearProgressIndicator(),
        ),
      );
    } else {
      if (_selectedLocation != null) {
        content = InkWell(
          onTap: _selectCustomLocation,
          child: Image.network(
            _selectedLocation!.locationImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      } else {
        content = Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text('Add Current Location'),
              onPressed: _selectCurrentLocation,
            ),
            const SizedBox(),
            TextButton.icon(
              icon: const Icon(Icons.pin_drop),
              label: const Text('Add Custom Location'),
              onPressed: _selectCustomLocation,
            ),
          ],
        ));
      }
    }

    return DottedBorder(
      dashPattern: const [7, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(20),
      color: Theme.of(context).colorScheme.onBackground,
      child: Container(
        height: 250,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: content,
      ),
    );
  }

  void _selectCustomLocation() async {
    final loc = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MapScreen();
        },
      ),
    );
    if (loc == null) return;
    setState(() {
      _selectedLocation = loc;
    });
    widget.onSelect(_selectedLocation);
  }

  void _selectCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    final placeLocation = await getCurrentLocation();
    setState(() {
      _selectedLocation = placeLocation;
      _isFetchingLocation = false;
    });
    widget.onSelect(_selectedLocation);
    // print(' ');
  }
}
