import 'package:flutter/foundation.dart';

class Expert with ChangeNotifier {
  final String id;
  final String firstName;
  final String lastName;
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
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.experienceCategory,
    required this.phoneNumber,
    required this.experience,
    required this.rate,
    required this.address,
    required this.email,
    required this.price,
  });

  String get fullName {
    return '$firstName $lastName';
  }

  Map<String, String> get expertMappedData {
    return {
      'Name': fullName,
      'Speciality': experienceCategory,
      'Phone Number': phoneNumber,
      'Experience': experience,
      'Rate': rate,
      'Address': address,
      'Email': email,
      'Price Per Hour': '\$$price',
    };
  }
}

class Experts with ChangeNotifier {
  final List<String> categories = [
    'All',
    'Medical',
    'professional',
    'Psychological',
    'family',
    'Business',
    'Computer Science',
    'Artificial Intelligence',
  ];

  String _searchInput = '';
  int _selectedCatergory = 0;

  final List<Expert> _experts = [
    Expert(
      id: '0',
      firstName: 'Ahmed',
      lastName: 'Ahmed',
      image: 'assets/illustrations/image.jpg',
      experienceCategory: 'Psychology medicine',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Big Hospital for 10 years",
      rate: '4.5',
      address: 'Germany',
      email: 'myemail@gmail.com',
      price: 5.9,
    ),
    Expert(
      id: '1',
      firstName: 'Sam',
      lastName: 'Sam',
      image: 'assets/illustrations/image1.jpg',
      experienceCategory: 'Computer Science',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Big Hospital for 10 years",
      rate: '4.4',
      address: 'Germany',
      email: 'myemail@gmail.com',
      price: 5.9,
    ),
    Expert(
      id: '2',
      firstName: 'Yahya',
      lastName: 'Yahya',
      image: 'assets/illustrations/image2.jpg',
      experienceCategory: 'Business',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Big Hospital for 10 years",
      rate: '3.9',
      address: 'Germany',
      email: 'myemail@gmail.com',
      price: 5.9,
    ),
    Expert(
      id: '3',
      firstName: 'Khaled',
      lastName: 'Khaled',
      image: 'assets/illustrations/image3.jpg',
      experienceCategory: 'Artificial Intelligence',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Big Hospital for 10 years",
      rate: '3.5',
      address: 'Germany',
      email: 'myemail@gmail.com',
      price: 5.9,
    ),
    Expert(
      id: '4',
      firstName: 'Lora',
      lastName: 'Lora',
      image: 'assets/illustrations/image4.jpg',
      experienceCategory: 'family',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Big Hospital for 10 years",
      rate: '4.9',
      address: 'Germany',
      email: 'myemail@gmail.com',
      price: 5.9,
    ),
    Expert(
      id: '5',
      firstName: 'Aya',
      lastName: 'Aya',
      image: 'assets/illustrations/image5.jpg',
      experienceCategory: 'Artificial Intelligence',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Big Hospital for 10 years",
      rate: '4.0',
      address: 'Germany',
      email: 'myemail@gmail.com',
      price: 5.9,
    ),
    Expert(
      id: '6',
      firstName: 'Reem',
      lastName: 'Reem',
      image: 'assets/illustrations/image6.jpg',
      experienceCategory: 'Medical',
      phoneNumber: "+9639843212",
      experience: "i have worked for a Big Hospital for 10 years",
      rate: '3.8',
      address: 'Germany',
      email: 'myemail@gmail.com',
      price: 5.9,
    ),
  ];

  List<Expert> get getFilteredExperts {
    var filteredExperts = [
      ..._experts
          .where((expert) =>
              _selectedCatergory == 0 ||
              categories[_selectedCatergory] == expert.experienceCategory)
          .toList()
    ];
    return [
      ...filteredExperts
          .where((expert) =>
              expert.firstName.toLowerCase().startsWith(_searchInput) ||
              expert.lastName.toLowerCase().startsWith(_searchInput) ||
              expert.experienceCategory.toLowerCase().startsWith(_searchInput))
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

  void toggleFavoriteStatusForSpecificExpert(String id) {
    final expertIndex = _experts.indexWhere((expert) => expert.id == id);
    _experts[expertIndex].isFavorite = !_experts[expertIndex].isFavorite;
    notifyListeners();
  }
}
