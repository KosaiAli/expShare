import 'package:flutter/foundation.dart';

class Expert with ChangeNotifier {
  final String id;
  final int age;
  final String firstName;
  final String lastName;
  final String image;
  final String experienceCategory;
  final String phoneNumber;
  final String experience;
  final String gender;
  bool isFavorite = false;

  Expert({
    required this.id,
    required this.age,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.experienceCategory,
    required this.phoneNumber,
    required this.experience,
    required this.gender,
  });
}

class Experts with ChangeNotifier {
  final List<String> catigories = [
    'Medical',
    'professional',
    'Psychological',
    'family',
    'Business',
  ];

  String _searchInput = '';

  final List<Expert> _experts = [
    Expert(
      id: '0',
      age: 30,
      firstName: 'Ahmed',
      lastName: 'Ahmed',
      image: 'assets/illustrations/image.jpg',
      experienceCategory: 'Psychology medicine',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Bonn Hospital for 10 years",
      gender: "male",
    ),
    Expert(
      id: '1',
      age: 33,
      firstName: 'Sam',
      lastName: 'Sam',
      image: 'assets/illustrations/image1.jpg',
      experienceCategory: 'Psychology medicine',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Bonn Hospital for 10 years",
      gender: "male",
    ),
    Expert(
      id: '2',
      age: 33,
      firstName: 'Yahya',
      lastName: 'Yahya',
      image: 'assets/illustrations/image2.jpg',
      experienceCategory: 'Psychology medicine',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Bonn Hospital for 10 years",
      gender: "male",
    ),
    Expert(
      id: '3',
      age: 33,
      firstName: 'Khaled',
      lastName: 'Khaled',
      image: 'assets/illustrations/image3.jpg',
      experienceCategory: 'Psychology medicine',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Bonn Hospital for 10 years",
      gender: "male",
    ),
    Expert(
      id: '4',
      age: 33,
      firstName: 'Lora',
      lastName: 'Lora',
      image: 'assets/illustrations/image4.jpg',
      experienceCategory: 'Psychology medicine',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Bonn Hospital for 10 years",
      gender: "male",
    ),
    Expert(
      id: '5',
      age: 33,
      firstName: 'Aya',
      lastName: 'Aya',
      image: 'assets/illustrations/image5.jpg',
      experienceCategory: 'Psychology medicine',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Bonn Hospital for 10 years",
      gender: "male",
    ),
    Expert(
      id: '6',
      age: 33,
      firstName: 'Reem',
      lastName: 'Reem',
      image: 'assets/illustrations/image6.jpg',
      experienceCategory: 'Psychology medicine',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Bonn Hospital for 10 years",
      gender: "male",
    ),
  ];

  List<Expert> get getExperts {
    return [
      ..._experts
          .where(
            (expert) =>
                expert.firstName.toLowerCase().startsWith(_searchInput) ||
                expert.lastName.toLowerCase().startsWith(_searchInput) ||
                expert.experienceCategory
                    .toLowerCase()
                    .startsWith(_searchInput),
          )
          .toList()
    ];
  }

  void searchInput(String value) {
    _searchInput = value;
    notifyListeners();
  }

  List<Expert> get getFavoritedExperts {
    return _experts.where((expert) => expert.isFavorite).toList();
  }

  Expert getExpertById(String id) {
    return _experts.firstWhere((expert) => expert.id == id);
  }

  void toggleFavoriteStatusForSpecificExpert(String id) {
    final expertIndex = _experts.indexWhere((expert) => expert.id == id);
    _experts[expertIndex].isFavorite = !_experts[expertIndex].isFavorite;
    notifyListeners();
  }
}
