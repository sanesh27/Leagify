import 'package:flutter/material.dart';

class UpdateMatch extends StatefulWidget {
  @override
  _UpdateMatchState createState() => _UpdateMatchState();
}

class _UpdateMatchState extends State<UpdateMatch> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stepper(
        currentStep: _currentStep,
        steps: [
          Step(
            title: Text("Step 1"),
            content: Text("This is the first step"),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: Text("Step 2"),
            content: Text("This is the second step"),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: Text("Step 3"),
            content: Text("This is the third step"),
            isActive: _currentStep >= 2,
          ),
        ],
        type: StepperType.vertical,
        controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
          print(controlsDetails.currentStep);
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green[300],
            ),
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: controlsDetails.onStepContinue,
                ),
                SizedBox(height: 16,),
                ElevatedButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: controlsDetails.onStepCancel,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
