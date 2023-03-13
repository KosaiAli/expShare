import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Models/catigory.dart';
import '../Models/expert.dart';
import '../https/config.dart';
import '../screens/login_screen.dart';

enum Language { english, arabic }

class Experts with ChangeNotifier {
  List<Catigory> categories = [];

  Language language = Language.arabic;
  set langValue(String lang) {
    if (lang == 'Eng') {
      language = Language.english;
      return;
    }
    language = Language.arabic;
  }

  List<Expert> _experts = [];
  late Expert? user;
  String _searchInput = '';
  int _selectedCatergory = 0;
  late bool isExpert;
  List favorites = [];

  void initCategories(String? val) {
    if (val == 'Ar') {
      language = Language.arabic;
    } else {
      language = Language.english;
    }
    categories = [
      Catigory(id: 1, type: language == Language.english ? 'All' : 'الكل'),
      Catigory(id: 2, type: language == Language.english ? 'Medical' : 'طبية'),
      Catigory(
          id: 3, type: language == Language.english ? 'Professional' : 'مهنية'),
      Catigory(
          id: 4,
          type: language == Language.english ? 'Psychological' : 'نفسية'),
      Catigory(id: 5, type: language == Language.english ? 'Family' : 'عائلية'),
      Catigory(
          id: 6,
          type: language == Language.english ? 'Business' : 'إدارة أعمال'),
    ];
    notifyListeners();
  }

  Future<List> getAvalibleTimes(String? expertID) async {
    var url = Uri.http(Config.host, 'api/getAvailableTimes');
    var header = await Config.getHeader();
    header.addEntries({'expertId': expertID ?? user!.id}.entries);
    var response = await http.get(url, headers: header);
    var decodedData = jsonDecode(response.body);
    return decodedData['data'];
  }

  Future<List> getBookedTimes() async {
    var url = Uri.http(Config.host, 'api/getAppointment');
    var header = await Config.getHeader();
    header.addEntries({'expertId': user!.id}.entries);
    var response = await http.get(url, headers: header);
    var decodedData = jsonDecode(response.body);

    return decodedData['data'];
  }

  set categoriesList(List values) {
    for (var value in values) {
      categories.add(Catigory(id: value['id'], type: value['type']));
    }
    notifyListeners();
  }

  Future getUserData() async {
    var url = Uri.http(Config.host, 'api/userProfile');
    var header = await Config.getHeader();

    await http.get(url, headers: header).then((value) {
      try {
        var decodedData = jsonDecode(value.body);

        isExpert = decodedData['data']['isExpert'] == 1;

        if (isExpert) {
          user = Expert.expertFromMap(decodedData['data']);
        } else {
          favorites = decodedData['favorite'];
        }
        notifyListeners();
      } catch (_) {
        return;
      }
    });
  }

  Future getAllExperts() async {
    if (isExpert) {
      return;
    }
    var url = Uri.http(Config.host, 'api/getAllExperts');
    var header = await Config.getHeader();
    await http
        .get(
      url,
      headers: header,
    )
        .then((value) {
      var decodedData = jsonDecode(value.body);
      List experts = decodedData['data'];

      _experts = experts.map((json) => Expert.expertFromMap(json)).toList();
    });

    for (var favorite in favorites) {
      _experts
          .elementAt(
            _experts.indexWhere(
                (element) => element.id == favorite['expert_id'].toString()),
          )
          .isFavorite = true;
    }
    notifyListeners();
  }

  List<Expert> get getFilteredExperts {
    var filteredExperts = [
      ..._experts
          .where((expert) =>
              _selectedCatergory == 0 ||
              categories[_selectedCatergory].id.toString() ==
                  expert.experienceCategory)
          .toList()
    ];
    return [
      ...filteredExperts
          .where((expert) =>
              expert.name.toLowerCase().startsWith(_searchInput) ||
              getCatigoryById(expert.experienceCategory)
                  .type
                  .toLowerCase()
                  .startsWith(_searchInput))
          .toList()
    ];
  }

  void selectCategory(int categoryIndex) {
    _selectedCatergory = categoryIndex;
    notifyListeners();
  }

  void searchInput(String value) {
    _searchInput = value;
    _selectedCatergory = 0;
    notifyListeners();
  }

  int get selectedCatergory {
    return _selectedCatergory;
  }

  List<Expert> get getFavoritedExperts {
    return _experts.where((expert) => expert.isFavorite).toList();
  }

  Expert getExpertById(String id) {
    return _experts.firstWhere((expert) => expert.id == id);
  }

  Map<String, String> expertMappedData(Expert expert) {
    return {
      language == Language.english ? 'Name' : 'الاسم': expert.name,
      language == Language.english ? 'Speciality' : 'الاختصاص':
          getCatigoryById(expert.experienceCategory).type,
      language == Language.english ? 'Phone Number' : 'رقم الهاتف':
          expert.phoneNumber,
      language == Language.english ? 'Experience' : 'الخبرات':
          expert.experience,
      language == Language.english ? 'Rate' : 'التقييم': expert.rate.toString(),
      language == Language.english ? 'Address' : 'العنوان': expert.address,
      language == Language.english ? 'Email' : 'الإيميل': expert.email,
      language == Language.english ? 'Price Per Hour' : 'سعر الجلسة':
          '\$${expert.price}',
    };
  }

  Catigory getCatigoryById(String id) {
    return categories.firstWhere((catigory) => catigory.id.toString() == id);
  }

  Future<void> toggleFavoriteStatusForSpecificExpert(String id) async {
    final expertIndex = _experts.indexWhere((element) => element.id == id);
    _experts[expertIndex].isFavorite = !_experts[expertIndex].isFavorite;
    var url = Uri.http(Config.host, 'api/AddToFavorite');
    var header = await Config.getHeader();
    await http.post(url, headers: header, body: jsonEncode({'expert_id': id}));

    notifyListeners();
  }

  Future<void> logot(BuildContext context) async {
    user = null;
    favorites = [];
    isExpert = false;
    var url = Uri.http(Config.host, 'api/logout');
    var header = await Config.getHeader();
    FlutterSecureStorage storage = const FlutterSecureStorage();

    await http.post(url, headers: header).then((value) async {
      await storage.delete(key: 'access_token').then((_) =>
          Navigator.pushNamedAndRemoveUntil(
              context, LogInScreen.routeName, (route) => false));
    });
    notifyListeners();
  }
}
