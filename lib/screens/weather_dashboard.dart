import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({Key? key}) : super(key: key);

  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  final _service = WeatherService();
  WeatherData? _weather;
  String _city = 'Dhaka';
  bool _loading = true;
  String? _error;

  static const _locations = <String, List<double>>{
    'Dhaka': [23.8103, 90.4125],
    'Chattogram': [22.3569, 91.7832],
    'Rajshahi': [24.3745, 88.6042],
    'Sylhet': [24.8949, 91.8687],
  };

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final coordinates = _locations[_city]!;
      final result = await _service.fetchWeather(
        city: _city,
        latitude: coordinates[0],
        longitude: coordinates[1],
      );
      if (mounted) setState(() => _weather = result);
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not load weather. Check your internet connection.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
        actions: [
          IconButton(onPressed: _loading ? null : _loadWeather, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadWeather,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: _city,
              decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
              items: _locations.keys.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _city = value);
                  _loadWeather();
                }
              },
            ),
            const SizedBox(height: 20),
            if (_loading) const SizedBox(height: 280, child: Center(child: CircularProgressIndicator())),
            if (_error != null) _ErrorCard(message: _error!, onRetry: _loadWeather),
            if (!_loading && _error == null && _weather != null) _WeatherContent(weather: _weather!),
            const SizedBox(height: 16),
            const Text('Data provided by Open-Meteo', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final WeatherData weather;
  const _WeatherContent({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.deepOrange,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(weather.location, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(weatherIcon(weather.weatherCode), style: const TextStyle(fontSize: 58)),
                Text('${weather.temperature.round()}°C', style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
                Text(weatherDescription(weather.weatherCode), style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Text('Feels like ${weather.apparentTemperature.round()}°C  •  Wind ${weather.windSpeed.round()} km/h'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft, child: Text('7-day forecast', style: Theme.of(context).textTheme.titleLarge)),
        const SizedBox(height: 8),
        ...weather.forecast.map((day) => Card(
          child: ListTile(
            leading: Text(weatherIcon(day.weatherCode), style: const TextStyle(fontSize: 28)),
            title: Text(_dayName(day.date)),
            subtitle: Text(weatherDescription(day.weatherCode)),
            trailing: Text('${day.maxTemperature.round()}° / ${day.minTemperature.round()}°'),
          ),
        )),
      ],
    );
  }

  String _dayName(DateTime date) => '${date.day}/${date.month}';
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [Text(message, textAlign: TextAlign.center), const SizedBox(height: 12), ElevatedButton(onPressed: onRetry, child: const Text('Try again'))]),
    ),
  );
}
