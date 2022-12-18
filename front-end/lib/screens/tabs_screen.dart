import 'package:expshare/providers/experts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/chats_screen.dart';
import '../screens/experts_overview_screen.dart';
import '../screens/favorites_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/TabsScreen';
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages = [];
  bool loading = true;
  @override
  void initState() {
    Provider.of<Experts>(context, listen: false).getAllExperts().then((value) {
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      {
        'page': !loading
            ? const ExpertsOverviewScreen()
            : const Center(child: CircularProgressIndicator()),
        'label': 'Experts',
        'icon': const Icon(Icons.home),
      },
      {
        'page': const FavoritesScreen(),
        'label': 'Favorites',
        'icon': const Icon(Icons.favorite),
      },
      {
        'page': const ChatsScreen(),
        'label': 'Chats',
        'icon': const Icon(Icons.chat),
      },
    ];
    return Scaffold(
      appBar: _selectedPageIndex != 0
          ? AppBar(
              title: const Text('EXPShare'),
            )
          : null,
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _selectedPageIndex,
        items: _pages
            .map(
              (page) => BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: page['icon'] as Widget,
                label: page['label'].toString(),
              ),
            )
            .toList(),
      ),
    );
  }
}
