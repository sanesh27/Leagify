import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TeamInCard extends StatelessWidget {
  const TeamInCard({Key? key, required this.team}) : super(key: key);
  final String team;

  String _logo(key) {
    String jsonString =
        '{"The Dudes": "assets/dudes.svg", "The Bokas": "assets/bokas.svg", "The Boros": "assets/theboros.svg", "The Goats": "assets/goats.svg"}';

    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    String value = jsonData.containsKey(key) ? jsonData[key] : "No Key";
    return value; // Output: "value2"
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        double height = constraints.maxHeight;
        double width = constraints.maxWidth;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Image.network(
            //   _logo(team),
            //   height: height * 0.1,
            //   // width: width * 0.08,
            // ),
            Expanded(
              flex: 2,
              child: SvgPicture.asset(
                _logo(team),
                width: width * 0.20,
                fit: BoxFit.contain,
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // Expanded(
            //   flex: 1,
            //   child: Text(team,
            //       style: kNormalSize.copyWith(
            //         fontWeight: FontWeight.bold,
            //       )),
            // ),
          ],
        );
      }
    );
  }
}
