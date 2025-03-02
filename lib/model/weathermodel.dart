class WeatherModel {

  String? cityName;
  int? temperature;
  String?climateStatus;
  String? message;


  WeatherModel.empty({required this.message});

  WeatherModel({required this.cityName,required this.temperature,required this.climateStatus});



}