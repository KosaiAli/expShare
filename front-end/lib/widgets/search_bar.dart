import 'package:flutter/material.dart';

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
      decoration: const InputDecoration(
        hintText: 'Search  for  Expert name or Category',
        hintStyle: TextStyle(color: Colors.white70, fontSize: 15),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        widget.forwardingSearchInput(value);
      },
    );
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: _searchMode ? _searchTextField() : const Text('EXPShare'),
      actions: [
        IconButton(
            icon: Icon(_searchMode ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                _searchMode = !_searchMode;
              });
            }),
      ],
    );
  }
}
