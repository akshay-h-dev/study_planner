
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/country.dart';

/// Handles communication with the REST Countries v5 API.
class CountryApiService {
  static const String _url = 'https://api.restcountries.com/countries/v5';

  // Demo key: suitable for this capstone/testing use.
  static const String _demoApiKey = 'rc_live_demo';

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse(_url).replace(
      queryParameters: {
        'limit': '100',
        'response_fields':
            'names.common,capitals,region,population,flag.emoji',
      },
    );

    final response = await http.get(
      uri,
      headers: const {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_demoApiKey',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load countries. HTTP ${response.statusCode}: '
        '${response.body}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object response.');
    }

    final dynamic data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      throw FormatException('Missing "data" object: ${response.body}');
    }

    final dynamic objects = data['objects'];
    if (objects is! List) {
      throw FormatException('Missing "data.objects" list: ${response.body}');
    }

    final countries = objects
        .map(
          (item) => Country.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();

    countries.sort((a, b) => a.name.compareTo(b.name));
    return countries;
  }
}
