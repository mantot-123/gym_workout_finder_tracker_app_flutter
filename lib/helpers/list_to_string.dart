String listToString(List<dynamic> list) {
  String result = "";
  for(int i = 0; i < list.length; i++) {
    if(i == list.length - 1) {
      result = result + list[i];
    } else {
      result = result + list[i] + ", ";
    }
  }
  return result;
}

String toNumberedListString(List<dynamic> list) {
  String result = "";
  for(int i = 0; i < list.length; i++) {
    int counter = i + 1;
    result = result + "${counter}.) ${list[i]}\n";
  }
  return result;
}