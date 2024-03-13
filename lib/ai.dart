import 'dart:convert';
import 'weather_service.dart';
import 'weather.dart';

class AI {
  Future<List<Weather>> _fetchWeatherData(String city) async {
    final s = await WeatherService().getData(city);
    final data = json.decode(s);
    List<Weather> weekForecast = [];

    // Прогноз на каждые 24 часа из списка
    for (var i = 0; i < data['list'].length; i += 8) {
      var dayData = data['list'][i];
      var tempMin = dayData['main']['temp'].toString();
      var description = dayData['weather'][0]['description'];
      weekForecast.add(Weather(tempMin, description));
    }
    return weekForecast;
  }

  Future<String> getAnswer(String question) async {
    final RegExp weatherPattern = RegExp(r'погода в городе (.+)');
    final match = weatherPattern.firstMatch(question.trim());

    if (match != null) {
      final String city = match.group(1)!;
      try {
        final weekForecast = await _fetchWeatherData(city);
        String forecastString = "Прогноз погоды в городе $city на неделю:\n";
        final List<String> daysOfWeek = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница'];
        for (int i = 0; i < weekForecast.length; i++) {
          forecastString += "${daysOfWeek[i]}: ${weekForecast[i]}\n";
        }
        return forecastString;
      } catch (error) {
        return "Не удалось получить данные о погоде для города $city.";
      }
    } else {
      return "Я могу помочь с информацией о погоде. Спросите, например, 'погода в городе Киров'.";
    }
  }
}