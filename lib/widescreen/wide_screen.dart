import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../mobile/Widgets/team_cards.dart';
import '../models/login_response_model.dart';
import '../services/provider/data_provider.dart';
import '../services/shared_services.dart';

class WideLayout extends StatefulWidget {
   WideLayout({Key? key}) : super(key: key);

  @override
  State<WideLayout> createState() => _WideLayoutState();
}

class _WideLayoutState extends State<WideLayout> {
  bool _isAdmin = false;

  Widget _userProfile(double height) {
    return FutureBuilder(
        future: SharedService.loginDetails(),
        builder:
            (BuildContext context, AsyncSnapshot<LoginResponseModel?> model) {
          if (model.hasData) {
            _isAdmin = model.data!.email == "kiran.silwal" || model.data!.email == "niraj.shrestha" || model.data!.email == "samin.maharjan" || model.data!.email == "sanish.maharjan"  ? true : false;
            return Text(
              '${model.data!.name}!',
              style: kHeading(const Color(0xFF3AA365), height),
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        });
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context,constraints) {
        double height = constraints.maxHeight;
        double width = constraints.maxWidth;
        return Scaffold(
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome,",
                          style: kGreetingStyle,
                        ),
                        _userProfile(height),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          SharedService.logout(context);
                        });
                      },
                      icon: const Icon(Icons.logout))
                ],
              ),
              const SizedBox(height: 40,),
          SizedBox(
          height: height * 0.4,
          child: Consumer<DataProvider>(
              builder: (context,data,child) {
                int completedGames = data.completedGames;
                return ListView.builder(
                  controller: ScrollController(
                      initialScrollOffset: width * 0.8 * (completedGames - 1)),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.matchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return MatchCards(model: model.data!, index: index, isAdmin: _isAdmin,);
                    return MatchCards(matchList: data.matchList[index],index: index,height: height/2,width: width/2,score: data.matchList[index].scores!,isAdmin: _isAdmin,);
                  },
                );
              }
          ),
        )

            ],
          ),
        );
      }
    );
  }
}
