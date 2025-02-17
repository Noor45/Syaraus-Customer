import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  String baseUrl = 'https://v6.exchangerate-api.com/v6/5f4a00370c4128737d8f98b8/latest/';

  // Function to fetch currency conversion rates
  Future<Map<String, dynamic>?> fetchCurrencyRates(String currencyCode) async {
    final String url = baseUrl;

    try {
      final response = await http.get(Uri.parse('${url}/$currencyCode'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> data = jsonDecode(response.body);
        return data['conversion_rates']; // Returns a map of currency rates
      } else {
        print("Failed to fetch currency rates: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching currency rates: $e");
      return null;
    }
  }
}
