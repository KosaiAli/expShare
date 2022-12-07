// import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart';

class Expert {
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
  final List<Expert> _experts = [
    Expert(
      id: '1',
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
      id: '2',
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
      id: '2',
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
      id: '2',
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
      id: '2',
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
      id: '2',
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

  List<Expert> get getAllExperts {
    return [..._experts];
  }
}
