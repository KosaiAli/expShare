import 'package:expshare/widgets/expert_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/experts.dart';

class ExpertsOverviewScreen extends StatelessWidget {
  const ExpertsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expertsData = Provider.of<Experts>(context).getAllExperts;
    final catigories = Provider.of<Experts>(context).catigories;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                children: const [
                  Text(
                    'Welcome!',
                    style: kTitleMediumStyle,
                  ),
                  Spacer(),
                  Icon(
                    Icons.notifications_none_rounded,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.favorite_border_outlined,
                  ),
                ],
              ),
            ),
            TextField(
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                fillColor: kTextFieldColor,
                filled: true,
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.all(15),
                // constraints: BoxConstraints.expand(height: 80),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Catigories :',
                style: kTitleSmallStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                ),
                shrinkWrap: true,
                children: catigories
                    .map(
                      (catigory) => Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: Text(
                          catigory,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Top Experts :',
                style: kTitleSmallStyle,
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: expertsData.length,
                itemBuilder: (ctx, index) {
                  final expertData = expertsData[index];
                  return ExpertItem(id: expertData.id);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
