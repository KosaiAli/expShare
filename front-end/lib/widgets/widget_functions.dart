import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/catigory.dart';
import '../constants.dart';
import '../providers/experts.dart';

Widget createDropDownList({required List items, required Function onTap}) {
  return DropdownButton(
      isExpanded: true,
      underline: Container(),
      dropdownColor: kTextFieldColor,
      itemHeight: 48,
      borderRadius: BorderRadius.circular(20),
      items: items.map((item) {
        print(item.runtimeType);
        return DropdownMenuItem(
          onTap: () => onTap(item),
          value: item.runtimeType == Catigory ? item.id : item,
          child: Text(
            item.runtimeType == Catigory ? item.type : item,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (_) {});
}

Directionality createTextForm(
    {required String hintText,
    String? Function(String?)? validator,
    required TextEditingController controller,
    Widget? prefix,
    required BuildContext context}) {
  var data = Provider.of<Experts>(context);
  return Directionality(
    textDirection: data.language == Language.english
        ? TextDirection.ltr
        : TextDirection.rtl,
    child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
            fillColor: const Color(0xFFE4E4ED),
            filled: true,
            hintText: hintText, //^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$
            prefixIcon: prefix),
        style: const TextStyle(color: Colors.black),
        validator: validator),
  );
}

void presentDatePicker(
    BuildContext context, String dateOfBirth, Function callBack) {
  showDatePicker(
          context: context,
          initialDate:
              dateOfBirth == '' ? DateTime.now() : DateTime.parse(dateOfBirth),
          firstDate: DateTime(1950),
          lastDate: DateTime.now())
      .then((pickedDate) => callBack(pickedDate));
}

Container createPickerField(BuildContext context,
    {required String text, required Widget child, required String hintText}) {
  var data = Provider.of<Experts>(context);
  return Container(
    height: 60,
    width: double.infinity,
    decoration: BoxDecoration(
        color: kTextFieldColor, borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        alignment: data.language == Language.english
            ? Alignment.centerLeft
            : Alignment.centerRight,
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
