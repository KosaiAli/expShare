import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';
import '../providers/experts.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60.0);
  final Function forwardingSearchInput;
  const SearchBar({
    Key? key,
    required this.forwardingSearchInput,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _searchMode = false;

  Widget _searchTextField() {
    return TextField(
      autofocus: true,
      cursorHeight: 25,
      cursorColor: Colors.white,
      style: const TextStyle(fontSize: 20),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: Provider.of<Experts>(context).language == Language.english
            ? 'Search  for  Expert name or Category'
            : 'ابحث باستخدام اسم الخبير او التصنيف',
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 15),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        widget.forwardingSearchInput(value);
      },
    );
  }

  var timeBackpressed = DateTime.now();
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      centerTitle: !_searchMode,
      title: _searchMode ? _searchTextField() : const Text('ExpShare'),
      actions: [
        WillPopScope(
          onWillPop: () async {
            if (_searchMode) {
              setState(() {
                widget.forwardingSearchInput('');
                _searchMode = false;
              });
              return false;
            }

            final difference = DateTime.now().difference(timeBackpressed);
            final isExitWarning =
                difference >= const Duration(milliseconds: 2000);

            timeBackpressed = DateTime.now();

            if (isExitWarning) {
              Fluttertoast.showToast(
                  gravity: ToastGravity.BOTTOM,
                  msg: Provider.of<Experts>(context, listen: false).language ==
                          Language.english
                      ? 'Press back again to exit'
                      : 'اضغط مرة أخرى للخروج',
                  fontSize: 16,
                  textColor: kPrimaryColor,
                  backgroundColor: Colors.white);
              return false;
            } else {
              Fluttertoast.cancel();
              return true;
            }
          },
          child: IconButton(
              icon: Icon(_searchMode ? Icons.clear : Icons.search),
              onPressed: () {
                setState(() {
                  _searchMode = !_searchMode;
                  if (!_searchMode) {
                    widget.forwardingSearchInput('');
                  }
                });
              }),
        ),
      ],
    );
  }
}
