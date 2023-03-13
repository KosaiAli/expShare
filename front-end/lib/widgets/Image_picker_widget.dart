import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/experts.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.isExpert});
  final bool isExpert;
  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String base64Image = '';

  File? pickedImage;
  void pickAnImage() async {
    await ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((xFileImage) {
      if (xFileImage == null) {
        return;
      }
      pickedImage = File(xFileImage.path);
      Provider.of<Experts>(context, listen: false).setPickedImage = pickedImage;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return widget.isExpert
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GestureDetector(
              onTap: pickAnImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: size.width / 4,
                    backgroundColor: Colors.white,
                    child: widget.isExpert
                        ? pickedImage == null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.width / 2),
                                child: Image.asset(
                                  'assets/illustrations/user.png',
                                  width: size.width / 2,
                                  height: size.width / 2,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.width / 4),
                                child: Image.file(
                                  pickedImage!,
                                  width: size.width / 2,
                                  height: size.width / 2,
                                  fit: BoxFit.cover,
                                ),
                              )
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(12.5)),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Hero(
            tag: 'signup',
            child: Image.asset(
              'assets/illustrations/fill_your_info.png',
              width: 300,
              height: 300,
            ),
          );
  }
}
