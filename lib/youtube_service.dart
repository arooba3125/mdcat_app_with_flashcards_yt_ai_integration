// Import the http package to perform HTTP requests.
import 'package:http/http.dart' as http;
// Import the dart:convert library to decode JSON data.
import 'dart:convert';

// Definition of the YouTubeService class.
class YouTubeService {
  // Define a constant API key (Note: this key should be kept secure and not hard-coded in production apps).
  static const apiKey = 'AIzaSyDJXqcE_yw_dZwhRC-3fSNWMtglV9m0WQs';

  // Static method fetchVideos, which can be called on the class itself, not on an instance of the class.
  static Future<List<dynamic>> fetchVideos(String query, {int maxResults = 100}) async {
    // Constructing the URI for the YouTube API request.
    var url = Uri.parse('https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&maxResults=$maxResults&key=$apiKey');

    try {
      // Performing an HTTP GET request to the YouTube API.
      var response = await http.get(url);
      // Check if the HTTP request was successful (status code 200).
      if (response.statusCode == 200) {
        // Decode the JSON response body to a dynamic data structure.
        var jsonData = jsonDecode(response.body);
        // Return the 'items' part of the JSON response which contains the videos.
        return jsonData['items'];
      } else {
        // Log an error message if the HTTP request was unsuccessful.
        print('Failed to fetch videos with status code: ${response.statusCode}');
        // Return an empty list if the fetch was unsuccessful.
        return [];
      }
    } catch (e) {
      // Catch any exceptions that occur during the HTTP request.
      print('Exception occurred: $e');
      // Return an empty list if an exception occurred.
      return [];
    }
  }
}
