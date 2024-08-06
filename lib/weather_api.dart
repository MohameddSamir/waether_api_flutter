import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wether_app/constants/constant.dart';
import 'package:wether_app/model/wether_data.dart';

class WeatherApi {
  final String baseUrl = "http://api.weatherapi.com/v1/current.json";

  Future<ApiData> getCurrentWeather(String city) async {
    String apiUrl = "$baseUrl?key=$apiKey&q=$city";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return ApiData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load weather");
      }
    } catch (e) {
      throw Exception("Failed to load weather");
    }
  }
}
