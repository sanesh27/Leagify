import 'package:flutter/material.dart';

class UpdateMatch extends StatefulWidget {
  const UpdateMatch({super.key});

  @override
  _UpdateMatchState createState() => _UpdateMatchState();
}

class _UpdateMatchState extends State<UpdateMatch> {
  final int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stepper(
        currentStep: _currentStep,
        steps: [
          Step(
            title: const Text("Step 1"),
            content: const Text("This is the first step"),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text("Step 2"),
            content: const Text("This is the second step"),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text("Step 3"),
            content: const Text("This is the third step"),
            isActive: _currentStep >= 2,
          ),
        ],
        type: StepperType.vertical,
        controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green[300],
            ),
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: controlsDetails.onStepContinue,
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16,),
                ElevatedButton(
                  onPressed: controlsDetails.onStepCancel,
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
