import 'dart:math';

import 'package:expshare/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/experts.dart';
import '../screens/expert_home_screen.dart';
import '../screens/expert_profile_screen.dart';
import '../screens/chats_screen.dart';
import '../screens/experts_overview_screen.dart';
import '../screens/favorites_screen.dart';
import '../widgets/widget_functions.dart';

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
    final expertData = Provider.of<Experts>(context);
    final language = expertData.language;
    _pages = [
      {
        'page': !loading
            ? expertData.isExpert
                ? const ExpertHomeScreen()
                : const ExpertsOverviewScreen()
            : const Center(child: CircularProgressIndicator()),
        'label': language == Language.english ? 'Home' : 'الرئيسية',
        'icon': const Icon(Icons.home),
      },
      {
        'page': const ChatsScreen(),
        'label': language == Language.english ? 'Chats' : 'المحادثات',
        'icon': const Icon(Icons.chat),
      },
      {
        'page': expertData.isExpert
            ? const ExpertProfileScreen()
            : const FavoritesScreen(),
        'label': expertData.isExpert
            ? language == Language.english
                ? 'Me'
                : 'حسابي'
            : language == Language.english
                ? 'Favorites'
                : 'المفضلة',
        'icon': Icon(expertData.isExpert ? Icons.person : Icons.favorite),
      },
    ];
    return Directionality(
      textDirection:
          language == Language.english ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: _selectedPageIndex != 0
            ? AppBar(
                title: const Text('EXPShare'),
              )
            : null,
        drawer: const NavigationDrawer(),
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
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late String pickedLang;

  @override
  void initState() {
    pickedLang = Provider.of<Experts>(context, listen: false).language ==
            Language.english
        ? 'En'
        : 'Ar';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    pickedLang = data.language == Language.english ? 'En' : 'Ar';
    print(data.user);
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection:
                pickedLang == 'En' ? TextDirection.ltr : TextDirection.rtl,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      pickedLang == 'En' ? 'language :' : 'اللغة: ',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      child: createPickerField(
                        context,
                        hintText: pickedLang,
                        text: pickedLang,
                        child: createDropDownList(
                            items: ['En', 'Ar'],
                            onTap: (item) {
                              data.initCategories(item);
                            }),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Provider.of<Experts>(context, listen: false)
                          .logot(context),
                      child: Transform.rotate(
                        angle: pickedLang == 'En' ? pi : 0,
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () => Provider.of<Experts>(context, listen: false)
                          .logot(context),
                      child: Text(
                        pickedLang == 'En' ? 'log out' : 'تسحيل الخروج',
                        style: kTitleSmallStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
