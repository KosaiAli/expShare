class Expert {
  final String id;
  final String name;
  final String image;
  final String experienceCategory;
  final String phoneNumber;
  final String experience;
  final double rate;
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

  static Expert expertFromMap(Map expert) {
    return Expert(
        id: expert['id'].toString(),
        name: expert['name'],
        image: expert['imageUrl'],
        experienceCategory: expert['specialty_id'].toString(),
        phoneNumber: expert['phoneNum'].toString(),
        experience: expert['details'],
        rate: expert['rate'] != null ? double.parse(expert['rate']) : 0,
        address: expert['address'],
        email: expert['email'].toString(),
        price: double.parse(expert['price'].toString()));
  }
}
