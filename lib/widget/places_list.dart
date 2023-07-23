import 'package:favourite_places/model/place.dart';
import 'package:favourite_places/screen/place_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.list});

  final List<Place> list;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'No places added yet!',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: (list[index].image != null)
              ? CircleAvatar(
                  backgroundImage: FileImage(list[index].image!),
                )
              : const CircleAvatar(child: Icon(Icons.photo_camera_back)),
          title: Text(
            list[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PlaceDetailsScreen(place: list[index]);
                  },
                  settings: const RouteSettings(name: '/details'),
                ));
          },
        );
      },
    );
  }
}
