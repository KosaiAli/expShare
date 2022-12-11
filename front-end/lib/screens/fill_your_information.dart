import 'dart:io';

import 'package:expshare/constants.dart';
import 'package:expshare/providers/experts.dart';
import 'package:expshare/widgets/buttons/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FillYourInformation extends StatefulWidget {
  static const routeName = 'FillYourInformation';
  const FillYourInformation({super.key});

  @override
  State<FillYourInformation> createState() => _FillYourInformationState();
}

class _FillYourInformationState extends State<FillYourInformation> {
  TextFormField createTextForm({required String hintText, Widget? suffix}) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        fillColor: const Color(0xFFE4E4ED),
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
            color: Colors.grey[700]), //^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$
        suffixIcon: suffix,
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  String _gender = '';
  String dateOfBirth = '';
  List<String> catigories = [];
  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          dateOfBirth = pickedDate.toString();
        });
        return;
      }
      setState(() {
        dateOfBirth = '';
      });
    });
  }

  Container createPickerField(
      {required String text, required Widget child, required String hintText}) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: kTextFieldColor, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Text(
              text.isNotEmpty ? text : hintText,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: text.isEmpty ? Colors.grey[700] : Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                child.runtimeType != Icon ? Expanded(child: child) : child,
              ],
            )
          ],
        ),
      ),
    );
  }

  File? pickedImage;
  void pickAnImage() async {
    await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        setState(() {
          pickedImage = File(value.path);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Text(
                        'Fill Your Profile',
                        style: kTitleSmallStyle,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: GestureDetector(
                    onTap: pickAnImage,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2), shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: size.width / 4,
                        child: pickedImage == null
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
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                createTextForm(hintText: 'Phone Number'),
                const SizedBox(height: 20),
                createTextForm(hintText: 'Address'),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _presentDatePicker,
                  child: createPickerField(
                      hintText: 'Date of birth',
                      child: const Icon(Icons.date_range),
                      text: dateOfBirth),
                ),
                const SizedBox(
                  height: 20,
                ),
                createPickerField(
                    hintText: 'Gender',
                    text: _gender,
                    child: createDropDownList(
                        items: ['male', 'female'],
                        onTap: (item) => setState(() {
                              _gender = item;
                            }))),
                const SizedBox(
                  height: 20,
                ),
                createPickerField(
                    text: 'catigory',
                    child: createDropDownList(
                        items: Provider.of<Experts>(context, listen: false)
                            .categories
                            .where((element) => !catigories.contains(element))
                            .toList(),
                        onTap: (item) {
                          setState(() {
                            catigories.add(item);
                          });
                        }),
                    hintText: 'Catigory'),
                if (catigories.isEmpty) const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: catigories.map((catigory) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 4),
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                catigory,
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => catigories.remove(catigory)),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                TextField(
                  minLines: 1,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    fillColor: const Color(0xFFE4E4ED),
                    filled: true,
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 20),
                AuthButton(
                  onPressed: () {},
                  child: const Text(
                    'Sign Up',
                    style: kButtonStyle,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createDropDownList({required List items, required Function onTap}) {
    return DropdownButton(
        isExpanded: true,
        underline: Container(),
        dropdownColor: kTextFieldColor,
        borderRadius: BorderRadius.circular(20),
        items: items
            .map((item) => DropdownMenuItem(
                  onTap: () => onTap(item),
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.black),
                  ),
                ))
            .toList(),
        onChanged: (_) {});
  }
}
