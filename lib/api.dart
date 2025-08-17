import "dart:io";
import "dart:typed_data";
import "package:http/http.dart" as http;
import "dart:convert" as convert;

class Search {
  final String API_KEY = const String.fromEnvironment("API_KEY");

    // Gets the URI object based on the workout attribute selected and data passed to it
  Uri getUri([String attribute = "", String value = ""]) {
    Uri? url;

    switch(attribute) {
      case "image":
        url = Uri.https(
          "exercisedb.p.rapidapi.com", "/image", {
            "resolution": "360",
            "exerciseId": value
          }
        );
      case "name":
        url = Uri.https("exercisedb.p.rapidapi.com", "/exercises/name/${value}");
      case "id":
        url = Uri.https("exercisedb.p.rapidapi.com", "/exercises/exercise/${value}");
      case "bodyPart":
        url = Uri.https("exercisedb.p.rapidapi.com", "/exercises/bodyPart/${value}");
      case "target":
        url = Uri.https("exercisedb.p.rapidapi.com", "/exercises/target/${value}");
      case "targetList":
        url = Uri.https("exercisedb.p.rapidapi.com", "/exercises/targetList");
      case "equipmentList":
        url = Uri.https("exericsedbv.p.rapidapi.com", "/exercises/equipmentList");
      default:
        url = Uri.https("exercisedb.p.rapidapi.com", "/exercises/"); // By default, the API should respond back with some first few exercises it receives
    }
    return url;
  }

  // GET JSON EXERCISE DATA
  Future<dynamic> getData([String attribute = "", String data = ""]) async {
    try {
      Uri url = getUri(attribute, data);
      http.Response response = await http.get(
        url,
        headers: {
          "x-rapidapi-key": API_KEY,
          "x-rapidapi-host" : "exercisedb.p.rapidapi.com"
        }
      );

      // Converts the JSON response into a list/map
      var dataList = convert.jsonDecode(response.body);
      return Future.value(dataList);
    } catch(ex) {
      print("An error occurrred while fetching data. Check that the API is currently reachable and try again.");
      return {};
    }
  }

  // GET IMAGE DATA 
  Future<Uint8List?> getImage(String id) async {
    try {
      Uri url = getUri("image", id);
      var response = await http.get(
        url,
        headers: {
          "x-rapidapi-key": API_KEY,
          "x-rapidapi-host" : "exercisedb.p.rapidapi.com"
        }
      );

      Uint8List imageData = response.bodyBytes;
      return Future.value(imageData);

    } catch(ex) {
      print("Failed to fetch image. An error has occurred. Check that the API is currently reachable and try again.");
    }
  }
}