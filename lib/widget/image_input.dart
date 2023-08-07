import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelect});

  @override
  State<ImageInput> createState() => _ImageInputState();
  final void Function(File? image) onSelect;
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    Widget content = DottedBorder(
        dashPattern: const [7, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        color: Theme.of(context).colorScheme.onBackground,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              const SizedBox(width: 10),
              Text(
                'Add Image',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ));
    if (_selectedImage != null) {
      content = DottedBorder(
          dashPattern: const [7, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          color: Theme.of(context).colorScheme.onBackground,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ));
    }

    return Container(
      height: 250,
      width: double.infinity,
      child: InkWell(onTap: _selectImage, child: content),
    );
  }

  void _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onSelect(_selectedImage);
  }
}
