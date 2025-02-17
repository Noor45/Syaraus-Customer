import 'package:customer/services/currency_service.dart';

class CurrencyConverter {
  Map<String, double> _conversionRates = {};

  // This function fetches the latest rates and updates the local rates
  Future<double> updateConversionRates(String currencyCode) async {
    CurrencyService currencyService = CurrencyService();
    var rates = await currencyService.fetchCurrencyRates(currencyCode);

    if (rates != null) {
      _conversionRates = rates.map((key, value) => MapEntry(key, value.toDouble()));
    }

    return _conversionRates[currencyCode] ?? 1.0;
  }

  // Get the conversion rate for a specific currency
  // double getConversionRate(String currencyCode) {
  //   return _conversionRates[currencyCode] ?? 1.0;  // Default to 1.0 if currency code is not found
  // }
}
