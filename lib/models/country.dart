
/// Represents a country returned by the REST Countries v5 API.
class Country {
  final String name;
  final String capital;
  final String region;
  final int population;

  // v5 provides a flag emoji. Keep the existing property name
  // so other code referring to flagUrl does not need to be changed.
  final String flagUrl;

  const Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.population,
    required this.flagUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final names = json['names'] as Map<String, dynamic>? ?? {};
    final flag = json['flag'] as Map<String, dynamic>? ?? {};
    final capitals = json['capitals'] as List<dynamic>? ?? [];

    String capitalName = 'No capital available';

    if (capitals.isNotEmpty && capitals.first is Map) {
      final capitalObject =
          Map<String, dynamic>.from(capitals.first as Map);
      capitalName = capitalObject['name']?.toString() ??
          'No capital available';
    }

    return Country(
      name: names['common']?.toString() ?? 'Unknown country',
      capital: capitalName,
      region: json['region']?.toString() ?? 'Unknown region',
      population: (json['population'] as num?)?.toInt() ?? 0,
      flagUrl: flag['emoji']?.toString() ?? '',
    );
  }
}
