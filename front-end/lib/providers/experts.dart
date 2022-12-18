import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../configuration/config.dart';

class Expert {
  final String id;
  final String name;
  final String image;
  final String experienceCategory;
  final String phoneNumber;
  final String experience;
  final String rate;
  final String address;
  final String email;
  final double price;
  bool isFavorite = false;

  Expert({
    required this.id,
    required this.name,
    required this.image,
    required this.experienceCategory,
    required this.phoneNumber,
    required this.experience,
    required this.rate,
    required this.address,
    required this.email,
    required this.price,
  });

  Map<String, String> get expertMappedData {
    return {
      'Name': name,
      'Speciality': experienceCategory,
      'Phone Number': phoneNumber,
      'Experience': experience,
      'Rate': rate,
      'Address': address,
      'Email': email,
      'Price Per Hour': '\$$price',
    };
  }

  static Expert expertFromMap(Map expert) {
    print(expert);
    return Expert(
        id: expert['id'].toString(),
        name: 'kosai',
        image: expert['imageUrl'],
        experienceCategory: expert['specialty_id'].toString(),
        phoneNumber: expert['phoneNum'].toString(),
        experience: expert['details'],
        rate: '100',
        address: expert['address'],
        email: expert['email'].toString(),
        price: double.parse(expert['price'].toString()));
  }
}

class Catigory {
  final int id;
  final String type;
  Catigory({required this.id, required this.type});
}

class Experts with ChangeNotifier {
  List<Catigory> categories = [];
  List<Expert> _experts = [];

  String _searchInput = '';
  int _selectedCatergory = 0;

  set categoriesList(List values) {
    for (var value in values) {
      categories.add(Catigory(id: value['id'], type: value['type']));
    }
    notifyListeners();
  }

  Future getAllExperts() async {
    var url = Uri.http(Config.host, 'api/getAllExperts');
    var accessToken =
        await const FlutterSecureStorage().read(key: 'access_token');

    await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    ).then((value) {
      var decodedData = jsonDecode(value.body);
      List experts = decodedData['data'];

      _experts = experts.map((json) => Expert.expertFromMap(json)).toList();
    });
    print(_experts);
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

  Catigory getCatigoryById(String id) {
    return categories.firstWhere((catigory) => catigory.id.toString() == id);
  }

  void toggleFavoriteStatusForSpecificExpert(String id) {
    final expertIndex = _experts.indexWhere((expert) => expert.id == id);
    _experts[expertIndex].isFavorite = !_experts[expertIndex].isFavorite;
    notifyListeners();
  }
}
