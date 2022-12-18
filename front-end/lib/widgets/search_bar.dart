import 'dart:math';

import 'package:expshare/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../configuration/config.dart';

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

  Future<void> _logot() async {
    var url = Uri.http(Config.host, 'api/logout');
    FlutterSecureStorage storage = const FlutterSecureStorage();
    var accessToken = await storage.read(key: 'access_token');
    await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    ).then((value) async {
      print(value.statusCode);
      print(value.body);
      await storage.delete(key: 'access_token').then((_) =>
          Navigator.pushNamedAndRemoveUntil(
              context, LogInScreen.routeName, (route) => false));
    });
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: _logot,
        child: Transform.rotate(
          angle: 180 * pi / 180,
          child: const Icon(
            Icons.logout_rounded,
            color: Colors.white,
          ),
        ),
      ),
      centerTitle: !_searchMode,
      title: _searchMode ? _searchTextField() : const Text('EXPShare'),
      actions: [
        WillPopScope(
          onWillPop: () async {
            if (_searchMode) {
              setState(() {
                _searchMode = false;
              });
            }
            if (!_searchMode) {
              widget.forwardingSearchInput('');
            } else {
              return true;
            }
            return false;
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
