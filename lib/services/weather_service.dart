import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final String location;
  final double temperature;
  final double apparentTemperature;
  final double windSpeed;
  final int weatherCode;
  final List<DailyForecast> forecast;

  const WeatherData({
    required this.location,
    required this.temperature,
    required this.apparentTemperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.forecast,
  });
}

class DailyForecast {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final int weatherCode;

  const DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCode,
  });
}

class WeatherService {
  Future<WeatherData> fetchWeather({
    required String city,
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current': 'temperature_2m,apparent_temperature,weather_code,wind_speed_10m',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
      'forecast_days': '7',
      'timezone': 'auto',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Weather service returned ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    final dates = (daily['time'] as List).cast<String>();
    final codes = (daily['weather_code'] as List).cast<num>();
    final maximums = (daily['temperature_2m_max'] as List).cast<num>();
    final minimums = (daily['temperature_2m_min'] as List).cast<num>();

    return WeatherData(
      location: city,
      temperature: (current['temperature_2m'] as num).toDouble(),
      apparentTemperature: (current['apparent_temperature'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      forecast: List.generate(
        dates.length,
        (index) => DailyForecast(
          date: DateTime.parse(dates[index]),
          maxTemperature: maximums[index].toDouble(),
          minTemperature: minimums[index].toDouble(),
          weatherCode: codes[index].toInt(),
        ),
      ),
    );
  }
}

String weatherDescription(int code) {
  if (code == 0) return 'Clear sky';
  if ([1, 2, 3].contains(code)) return 'Partly cloudy';
  if ([45, 48].contains(code)) return 'Foggy';
  if ([51, 53, 55, 56, 57].contains(code)) return 'Drizzle';
  if ([61, 63, 65, 66, 67].contains(code)) return 'Rain';
  if ([71, 73, 75, 77].contains(code)) return 'Snow';
  if ([80, 81, 82].contains(code)) return 'Rain showers';
  if ([95, 96, 99].contains(code)) return 'Thunderstorm';
  return 'Unknown';
}

String weatherIcon(int code) {
  if (code == 0) return '☀️';
  if ([1, 2, 3].contains(code)) return '⛅';
  if ([45, 48].contains(code)) return '🌫️';
  if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82].contains(code)) return '🌧️';
  if ([71, 73, 75, 77].contains(code)) return '❄️';
  if ([95, 96, 99].contains(code)) return '⛈️';
  return '🌡️';
}
