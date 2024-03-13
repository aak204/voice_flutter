class Weather {
  late String tempMin;
  late String description;

  Weather(this.tempMin, this.description);

  @override
  String toString() {
    return 'Температура: $tempMin°C, Облачность: $description';
  }
}
