import 'package:expshare/widgets/choose_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../Models/catigory.dart';
import '../constants.dart';
import '../providers/experts.dart';

Widget createDropDownList(
    {required List items, required Function onTap, required context}) {
  return DropdownButton(
      isExpanded: true,
      underline: Container(),
      dropdownColor: kTextFieldColor,
      itemHeight: 48,
      borderRadius: BorderRadius.circular(20),
      items: items.map((item) {
        return DropdownMenuItem(
          onTap: () => onTap(item),
          value: item.runtimeType == Catigory ? item.id : item,
          child: Row(
            mainAxisAlignment:
                Provider.of<Experts>(context, listen: false).language ==
                        Language.english
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
            children: [
              Text(
                item.runtimeType == Catigory ? item.type : item,
                style: const TextStyle(color: Colors.black),
              ),
            ],
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
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey),
            hintText: hintText, //^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$
            prefixIcon: prefix),
        style: const TextStyle(color: Colors.black),
        validator: validator),
  );
}

void presentDatePicker(
    BuildContext context, String? dateOfBirth, Function callBack) {
  showDatePicker(
          context: context,
          initialDate: dateOfBirth == null
              ? DateTime.now()
              : DateTime.parse(dateOfBirth),
          firstDate: DateTime(1950),
          lastDate: DateTime.now())
      .then((pickedDate) => callBack(pickedDate));
}

Container createPickerField(BuildContext context,
    {String? text,
    required Widget child,
    required String hintText,
    required Type typeExpcted}) {
  var data = Provider.of<Experts>(context);
  if (text != null && typeExpcted == DateTime) {
    print(text);
    var date = intl.DateFormat('yyyy-MM-dd', 'en').parseLoose(text);

    text = intl.DateFormat(
            data.language == Language.english ? 'dd/MM/yyyy' : 'yyyy/MM/dd',
            data.language == Language.english ? 'en' : 'ar')
        .format(date);
  }
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
            text ?? hintText,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: text != null && text.isEmpty
                    ? Colors.grey[700]
                    : Colors.black),
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

Widget daysPicker(context) {
  var data = Provider.of<Experts>(context);
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: data.translateddays
            .where((element) => data.translateddays.indexOf(element) < 4)
            .map((e) {
          var index = data.translateddays.indexOf(e);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ChooseCard(
              listOfDays: data.listOfDays,
              callBak: () {
                data.addToDaysList(index);
              },
              element: weekDays[index],
              text: e,
            ),
          );
        }).toList(),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: data.translateddays
            .where((element) => data.translateddays.indexOf(element) >= 4)
            .map((e) {
          var index = data.translateddays.indexOf(e);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ChooseCard(
              listOfDays: data.listOfDays,
              callBak: () {
                data.addToDaysList(index);
              },
              element: weekDays[index],
              text: e,
            ),
          );
        }).toList(),
      ),
    ],
  );
}

Widget catsWidget(context) {
  var data = Provider.of<Experts>(context);
  List<Widget> widgets = [];
  for (int i = 0; i < data.categories.length; i += 2) {
    if (i + 1 < data.categories.length) {
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChooseCard(
                text: data.translatedCat[i],
                element: data.categories[i],
                listOfDays: data.categoriesSet,
                callBak: () {
                  data.selectCategory(i);
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChooseCard(
                text: data.translatedCat[i + 1],
                element: data.categories[i + 1],
                listOfDays: data.categoriesSet,
                callBak: () {
                  data.selectCategory(i + 1);
                }),
          ),
        ],
      ));
    } else {
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChooseCard(
                text: data.translatedCat[i],
                element: data.categories[i],
                listOfDays: data.categoriesSet,
                callBak: () {
                  data.selectCategory(i);
                }),
          ),
        ],
      ));
    }
  }
  return Column(
    children: widgets,
  );
}
