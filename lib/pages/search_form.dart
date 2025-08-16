import 'package:flutter/material.dart';
import "../widgets/button.dart";
import "../widgets/input_box.dart";
import "../widgets/ui_scaffold.dart";
import "search_results.dart";

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  TextEditingController nameController = TextEditingController();
  String alertMsg = "";

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Search",
      scaffoldBody: Center(
        child: Container(
          width: 500,
          height: 300,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIInputBox(label: "Enter the name of the workout...", inputController: nameController),

              UIButton(label: "Search", onPressedAction: () {
                if(nameController.text == "") {
                  setState(() { 
                    alertMsg = "Please enter the name of the workout you want to search!";
                  });
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return SearchResultsPage(type: "name", query: nameController.text);
                }));
              }),

              Text(alertMsg)
            ],
          )
        ),
      ) 
    );
  }
}