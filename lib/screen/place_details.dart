import 'package:favourite_places/model/place.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget? background = (widget.place.image != null)
        ? Image.file(
            widget.place.image!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
          );
    return Scaffold(
      appBar: AppBar(title: Text(widget.place.title)),
      body: Stack(
        children: [
          background,
        ],
      ),
    );
  }
}
