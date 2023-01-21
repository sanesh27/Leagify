import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leagify/models/game.dart';
import 'package:leagify/models/game_response.dart';
import 'package:leagify/models/stats_post.dart';
import 'package:leagify/services/api_service.dart';

import '../config.dart';
import '../models/player.dart';

class UpdateMatch extends StatefulWidget {
  const UpdateMatch({super.key, required this.gameId});
  final int gameId;
  @override
  _UpdateMatchState createState() => _UpdateMatchState();
}

class _UpdateMatchState extends State<UpdateMatch> {
   int _currentStep = 0;
  GameResponse? gameResponse;
   List<Player> team1players = [];
   List<Player> team2players = [];
   List<Player> players = [];
   List<Team> teams = [];
   Player? _selectedTeam;
   final _controller = TextEditingController();
   List<Map<String,int>> stats = [
     {
      "Goal": 1
    },{
      "Assist": 2
    },{
      "Yellow": 3
    },{
      "Red": 4
    },
  ];
   Map<String,int>? _selectedStats;
   int? minutes;


   void onTeamSelected(value) {
       _selectedTeam = value;
   }
   void onStatsSelected(value) {
     _selectedStats = value;
   }







  Future<List<Player>> _getData() async {
      gameResponse = await APIService.getGameResponse(widget.gameId);
        teams.add(Team(gameResponse!.team1Id, gameResponse!.team1Name));
      teams.add(Team(gameResponse!.team2Id, gameResponse!.team2Name));
      team1players = await APIService.getPlayers(teams[0].id);
      team2players = await APIService.getPlayers(teams[1].id);
      players = team1players + team2players;
      return players;
  }


  @override
  Widget build(BuildContext context) {
    return Material(

      child: FutureBuilder(
        future: _getData(),
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data);
            Team dropdownValue = teams[0];
          return Column(
            children: [
              Stepper(
                currentStep: _currentStep,
                steps: [
                  Step(
                    title: const Text("Please choose player"),
                    content: CreateDropDown(teams: players,onItemSelected:onTeamSelected),
                    isActive: _currentStep >= 0,
                  ),
                  Step(
                    title: Text(_selectedTeam?.fname == null ? "Choose Player" :"What did ${_selectedTeam?.fname} do?" ),
                    content:CreateStatsDropDown(
                      stats: stats,
                      onItemSelected: onStatsSelected,
                    ),
                    isActive: _currentStep >= 1,
                  ),
                  Step(
                    title:  Text(_selectedStats?.keys == null ? "choose time" :" ${_selectedStats?.keys} at what time?"),
                    content:  TextField (
                      controller: _controller,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Time',
                          hintText: 'Ex. 15',
                        prefixIcon: Icon(Icons.watch_later_outlined),enabledBorder: OutlineInputBorder(),
                      ),cursorColor: Colors.red,keyboardType: TextInputType.number, onSubmitted: (value){
                        setState(() {
                          minutes = int.parse(_controller.text);
                        });
                    },
                    )  ,
                    isActive: _currentStep == 1,
                  ),
                ],
                type: StepperType.vertical,
                controlsBuilder:
                    (BuildContext context, ControlsDetails controlsDetails) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {

                              if (_currentStep >= 2) {
                                print("Step = ${_currentStep}");
                                _currentStep = _currentStep;
                                print(minutes.toString());
                              } else {
                                _currentStep = _currentStep + 1;
                              }

                                });


                          },
                          child: const Text(
                            "Continue",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
              ElevatedButton(
                child: Text('Upload'),
                onPressed: () {
                  setState(() {
                    minutes = int.parse(_controller.text);
                    print(minutes!.runtimeType.toString() + ' ${_selectedTeam!.id.runtimeType}' + ' ${_selectedStats!.values.first.runtimeType}' + ' ${widget.gameId}');
                    StatsPost postdata = StatsPost(statstype: _selectedStats!.values.first, player: _selectedTeam!.id, game: widget.gameId, stats_time: minutes!);

                    setState(() {
                      APIService.postStats(postdata).then((value) => _popUp(value));
                      Navigator.pop(context);
                    });
                  });
                },
              ),
            ],
          );
        } else {
            return const Center(child: CircularProgressIndicator());
          }
      }
      ),
    );
  }
  void _popUp(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(text),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

}



class CreateDropDown extends StatefulWidget {
  const CreateDropDown({Key? key, required this.teams, required this.onItemSelected}) : super(key: key);
  final List<Player> teams;
  final Function onItemSelected;

  @override
  State<CreateDropDown> createState() => _CreateDropDownState();
}

class _CreateDropDownState extends State<CreateDropDown> {
  Player? _selectedTeam;
  @override
  Widget build(BuildContext context) {

    return DropdownButton<Player>(
        value: _selectedTeam,
        items: widget.teams.map((team) => DropdownMenuItem<Player>(
          value: team,
          child: Text(team.fname),
        )).toList(),
        onChanged: (value) {

          setState(() {

            _selectedTeam = value;
            widget.onItemSelected(value);

          }
          );
        },hint: Text(_selectedTeam?.fname ?? 'Select Player'));
  }
}

class CreateStatsDropDown extends StatefulWidget {
  const CreateStatsDropDown({Key? key, required this.onItemSelected, required this.stats}) : super(key: key);
  final List<Map<String,int>> stats;
  final Function onItemSelected;

  @override
  State<CreateStatsDropDown> createState() => _CreateStatsDropDownState();
}

class _CreateStatsDropDownState extends State<CreateStatsDropDown> {
  Map<String,int>? _selectedTeam;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Map<String,int>>(
        value: _selectedTeam,
        items: widget.stats.map((team) => DropdownMenuItem<Map<String,int>>(
          value: team,
          child: Text(team.toString()),
        )).toList(),
        onChanged: (value) {
          widget.onItemSelected(value);
          setState(() {

            _selectedTeam = value;


          }
          );
        },hint: Text( _selectedTeam?.toString() ?? 'Select stats' ));
  }
}


class Team {
  final int id;
  final String name;

  Team(this.id, this.name);

}



