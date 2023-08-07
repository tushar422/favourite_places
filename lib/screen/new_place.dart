import 'dart:io';

import 'package:favourite_places/model/place.dart';
import 'package:favourite_places/provider/places_provider.dart';
import 'package:favourite_places/widget/image_input.dart';
import 'package:favourite_places/widget/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  final _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a place'),
        actions: [
          IconButton(onPressed: _addPlace, icon: const Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 20),
              ImageInput(
                onSelect: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(height: 15),
              LocationInput(
                onSelect: (location) {
                  _selectedLocation = location;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addPlace() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a title.'),
        duration: Duration(seconds: 3),
      ));
      return;
    } 
    if(_selectedLocation==null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select the location.'),
        duration: Duration(seconds: 3),
      ));
      return;
    }
    ref.read(placesProvider.notifier).createPlace(
            Place(
              title: title,
              image: _selectedImage,
              location: _selectedLocation!,
            ),
          );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
