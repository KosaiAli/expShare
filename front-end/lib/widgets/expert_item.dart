import 'package:flutter/material.dart';

class ExpertItem extends StatelessWidget {
  final String image;
  final String name;
  final String experienceCategory;
  const ExpertItem({
    super.key,
    required this.image,
    required this.name,
    required this.experienceCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      height: 125,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      experienceCategory,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        iconButtonBuilder(context, () => {}, Icons.phone),
                        iconButtonBuilder(context, () => {}, Icons.message),
                        const Text(
                          '4.6/5',
                          style: TextStyle(color: Colors.amber, fontSize: 16),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  iconButtonBuilder(context, () => {}, Icons.favorite_border,
                      size: 25),
                  iconButtonBuilder(context, () => {}, Icons.person, size: 25),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget iconButtonBuilder(
    BuildContext context, VoidCallback onPressed, IconData icon,
    {double size = 20.0}) {
  return IconButton(
    onPressed: onPressed,
    icon: Icon(
      icon,
      color: Theme.of(context).primaryColor,
      size: size,
    ),
  );
}
