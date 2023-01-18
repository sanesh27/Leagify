import 'package:flutter/material.dart';
import 'package:leagify/constants.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:leagify/models/match_list.dart';

class UpdateMatch extends StatefulWidget {
   UpdateMatch({Key? key}) : super(key: key);


  @override
  State<UpdateMatch> createState() => _UpdateMatchState();
}

class _UpdateMatchState extends State<UpdateMatch> {
  int status = 0;
  int winner = 0;


  @override
  Widget build(BuildContext context) {
    List<dynamic> productTypesList = [];
    productTypesList.add({"id": "simple", "name": "Simple"});
    productTypesList.add({"id": "variable", "name": "Variable"});
    return Scaffold(
      backgroundColor: kCanvasColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormHelper.inputFieldWidget(
            context,
            "Status",
            "Status",
                (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "username cant be empty";
              }
              return null;
            },
                (onSavedVal) {
              status = onSavedVal;
            },
            borderColor: kCanvasColor,
            suffixIcon: const Icon(
              Icons.person,
            ),
            borderFocusColor: kBrandColor,
            textColor: Colors.black54,
            hintColor: Colors.black12,
            borderRadius: 16,

            backgroundColor: kScoreFutureMatch,
            prefixIconColor: Colors.black12,
          ),
          FormHelper.dropDownWidget(
            context,
            "Select Product Type",
            "",
            productTypesList,
                (onChangedVal) {

            },
                (onValidateVal) {
              if (onValidateVal == null) {
                return 'Please Select Product Type';
              }

              return null;
            },
            borderFocusColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(context).primaryColor,
            borderRadius: 10,
          ),


        ],
      ),

    );
  }
}
