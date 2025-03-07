import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> getImageByQuery(String query) async {
  await dotenv.load();

  String url = "https://api.pexels.com/v1/search?query=$query&per_page=1";
  if (dotenv.env["API_KEY"] == null){
    print("you need to add a .env file at the top level and add an API_KEY value for the pexels website");
  }
  http.Response response = await http.get(Uri.parse(url), headers: {"Authorization": dotenv.env["API_KEY"] ?? ""});
  if (response.statusCode != 200){
    print("failed to acquire image");
    return null;
  }
  Map<String, dynamic> jsonResponse = jsonDecode(response.body);
  String photoSource = jsonResponse["photos"][0]["src"]["medium"];
  return photoSource;
}


void main() {
  String query = "Boring, Oregon"; // You can change the search query here
  getImageByQuery(query);  // Call the function with the query
}