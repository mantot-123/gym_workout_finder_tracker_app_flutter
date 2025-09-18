import 'package:flutter/material.dart';
import "../widgets/ui/ui_button.dart";
import "../widgets/ui/ui_input_box.dart";
import "../widgets/ui/ui_scaffold.dart";
import "search_results.dart";

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  String alertMsg = "";

  String? checkName(String? value) {
    if(value == "") {
      return "Please enter the name of the exercise to search";
    }
    return null;
  }

  void onSearchBtnPressed() {
    final isValid = _formKey.currentState!.validate();

    if(isValid) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SearchResultsPage(type: "name", query: nameController.text);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      appBarTitle: "Search",
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: 500,
            height: 300,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(label: Text("Enter the name of the exercise...")), 
                  controller: nameController,
                  validator: checkName
                ),
        
                UIButton(label: "Search", onPressed: onSearchBtnPressed),
        
                Text(alertMsg)
              ],
            )
          ),
        ),
      ) 
    );
  }
}