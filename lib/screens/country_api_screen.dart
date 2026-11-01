import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/country_api_service.dart';

/// Displays country information fetched from an external API.
class CountryApiScreen extends StatefulWidget {
  const CountryApiScreen({super.key});

  @override
  State<CountryApiScreen> createState() => _CountryApiScreenState();
}

class _CountryApiScreenState extends State<CountryApiScreen> {
  // Service responsible for retrieving API data.
  final CountryApiService _apiService = CountryApiService();

  // Controller for searching countries.
  final TextEditingController _searchController = TextEditingController();

  List<Country> _countries = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Fetch data when the screen is first opened.
    _loadCountries();
  }

  /// Retrieves country data from the API.
  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final countries = await _apiService.fetchCountries();

      if (!mounted) return;

      setState(() {
        _countries = countries;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  /// Filters countries using the search text.
  List<Country> get _filteredCountries {
    if (_searchQuery.trim().isEmpty) {
      return _countries;
    }

    final query = _searchQuery.toLowerCase().trim();

    return _countries.where((country) {
      return country.name.toLowerCase().contains(query) ||
          country.capital.toLowerCase().contains(query) ||
          country.region.toLowerCase().contains(query);
    }).toList();
  }

  /// Formats population values with thousands separators.
  String _formatPopulation(int population) {
    return population.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Countries'),
        centerTitle: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search field for filtering API results.
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search countries...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();

                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            // Displays loading, error, empty, or list content.
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  /// Builds the appropriate UI based on the API state.
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Unable to load countries',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadCountries,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final countries = _filteredCountries;

    if (countries.isEmpty) {
      return const Center(child: Text('No countries found.'));
    }

    return RefreshIndicator(
      onRefresh: _loadCountries,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),

              // Country flag retrieved from the API.
              leading: SizedBox(
                width: 64,
                height: 44,
                child: country.flagUrl.isNotEmpty
                    ? Text(
                        country.flagUrl,
                        style: const TextStyle(fontSize: 32),
                      )
                    : const Icon(Icons.flag, size: 36),
              ),

              // Country name and additional information.
              title: Text(
                country.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Capital: ${country.capital}\n'
                  'Region: ${country.region}\n'
                  'Population: ${_formatPopulation(country.population)}',
                ),
              ),

              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
