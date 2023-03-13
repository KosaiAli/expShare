import 'dart:convert';
import 'dart:io';

import 'package:expshare/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Models/user.dart';
import '../Models/catigory.dart';
import '../Models/expert.dart';
import '../https/config.dart';
import '../screens/login_screen.dart';

enum Language { english, arabic }

class Experts with ChangeNotifier {
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController costController = TextEditingController();
  Set listOfDays = {};
  Set categoriesSet = {};
  DateTime? dayStart;
  DateTime? dayEnd;
  File? profilePic;

  List categories = [];
  List translatedCat = [];
  List translateddays = [];

  Language language = Language.arabic;

  List<Expert> _experts = [];
  dynamic user;
  String _searchInput = '';
  int _selectedCatergory = 0;
  late bool isExpert;
  List favorites = [];

  void clearForm() {
    // numberController.clear();
    // nameController.clear();
    // addressController.clear();
    // descriptionController.clear();
    // priceController.clear();
    // costController.clear();
    // listOfDays = {};
    // categoriesSet = {};
    // dayEnd = null;
    // dayStart = null;
    // profilePic = null;
  }

  set setDayStart(date) {
    dayStart = date;
  }

  set setDayEnd(date) {
    dayEnd = date;
  }

  set setPickedImage(pickedImage) {
    profilePic = pickedImage;
  }

  void addToDaysList(index) {
    if (listOfDays.contains(weekDays[index])) {
      listOfDays.remove(weekDays[index]);
      notifyListeners();
      return;
    }
    listOfDays.add(weekDays[index]);
    notifyListeners();
  }

  Future<void> initCategories(List cats) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    var lang = await storage.read(key: 'language');
    if (lang != null) {
      language = lang == 'Ar' ? Language.arabic : Language.english;
    } else {
      language = Language.english;

      await storage.write(key: 'language', value: 'Ar');
    }

    categories = cats.map((e) => e['name']).toList();

    await translate();
    notifyListeners();
  }

  Future<void> setLanguage(lang) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    if (lang == 'En') {
      await storage.write(key: 'language', value: 'En');
      language = Language.english;
    } else {
      await storage.write(key: 'language', value: 'Ar');
      language = Language.arabic;
    }
    await translate();
    notifyListeners();
  }

  Future<void> translate() async {
    translatedCat = [];
    translateddays = [];
    if (language == Language.arabic) {
      for (var element in categories) {
        if (element == 'Medical') {
          translatedCat.add('طبية');
        }
        if (element == 'Professional') {
          translatedCat.add('مهنية');
        }
        if (element == 'Psychological') {
          translatedCat.add('نفسية');
        }
        if (element == 'Family') {
          translatedCat.add('عائلية');
        }
        if (element == 'Business / management') {
          translatedCat.add('إدارة الإعمال');
        }
      }
      for (var element in weekDays) {
        if (element == 'Sun') {
          translateddays.add('الأحد');
        }
        if (element == 'Mon') {
          translateddays.add('الاثنين');
        }
        if (element == 'Tue') {
          translateddays.add('الثلاثاء');
        }
        if (element == 'Wed') {
          translateddays.add('الأربعاء');
        }
        if (element == 'Thu') {
          translateddays.add('الخميس');
        }
        if (element == 'Fri') {
          translateddays.add('الجمعة');
        }
        if (element == 'Sat') {
          translateddays.add('السبت');
        }
      }
      return;
    } else {
      translatedCat = categories;
      translateddays = weekDays;
    }
  }

  Future<Map> getAvalibleTimes(String? expertID) async {
    var url = Uri.http(Config.host, 'api/getAvailableTimes');
    var header = await Config.getHeader();
    header.addEntries({'expertId': expertID ?? (user as Expert).id}.entries);
    var response = await http.get(url, headers: header);
    var decodedData = jsonDecode(response.body);

    return decodedData;
  }

  Future<List> getBookedTimes() async {
    var url = Uri.http(Config.host, 'api/getAppointment');
    var header = await Config.getHeader();
    header.addEntries({'expertId': (user as Expert).id}.entries);
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

  void selectCategory(i) {
    if (categoriesSet.contains(categories[i])) {
      categoriesSet.remove(categories[i]);
      notifyListeners();
      return;
    }
    categoriesSet.add(categories[i]);
    notifyListeners();
  }

  Future getUserData() async {
    var url = Uri.http(Config.host, 'api/userProfile');
    var header = await Config.getHeader();

    await http.get(url, headers: header).then((value) {
      try {
        var decodedData = jsonDecode(value.body);
        print(decodedData);
        isExpert = decodedData['data']['isExpert'] == 1;

        if (isExpert) {
          user = Expert.expertFromMap(decodedData['data']);
        } else {
          user = User.userfromJson(decodedData['data']);

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
