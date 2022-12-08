import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/chats_screen.dart';
import '../screens/experts_overview_screen.dart';
import '../screens/favorites_screen.dart';
import '../providers/experts.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/TabsScreen';
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages = [];

  @override
  void initState() {
    _pages = [
      {
        'page': const ExpertsOverviewScreen(),
        'title': 'Experts',
        'icon': Icons.home
      },
      {'page': const FavoritesScreen(), 'title': 'Chats', 'icon': Icons.chat},
      {'page': const ChatsScreen(), 'title': 'Me', 'icon': Icons.person},
    ];
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Experts(),
        )
      ],
      child: Scaffold(
        body: _pages[_selectedPageIndex]['page'] as Widget,
        bottomNavigationBar: MyBottomBar(
          pages: _pages,
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
        ),
      ),
    );
  }
}

class MyBottomBar extends StatelessWidget {
  const MyBottomBar(
      {Key? key,
      required this.pages,
      required this.onTap,
      required this.currentIndex})
      : super(key: key);

  final List<Map<String, Object>> pages;
  final Function(int)? onTap;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -3),
            blurRadius: 15,
            blurStyle: BlurStyle.outer,
          ),
        ],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: pages.map((page) {
          final index = pages.indexOf(page);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () => onTap!(index),
                  child: Icon(
                    page['icon'] as IconData,
                    color: currentIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  )),
              Text(
                page['title'] as String,
                style: TextStyle(
                    color: currentIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    fontSize: 12),
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}
