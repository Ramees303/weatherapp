import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weatherapp/model/weathermodel.dart';

class HomeService {

     int? temp;
     String? place;
     String? cloudstatus;
     var responsedata;
     var weatherdata;


   Future <WeatherModel> getWeatherDataUsingCity(String cityname) async{

    if(cityname.isEmpty){
      return WeatherModel.empty(message: 'enter your city'); 
    }
       
      try{
      
        responsedata = await http.get(Uri.https('api.openweathermap.org','data/2.5/weather',{'q': cityname ,'appid':'37db4da9615e634a5c958c643bf56641'}));

        if(responsedata.statusCode==200){

        weatherdata=jsonDecode(responsedata.body);

        print(weatherdata);

        temp=convertKelvintoCelcius(weatherdata["main"]["temp"]);
        place=weatherdata["name"];
        cloudstatus=weatherdata["weather"][0]["main"];
       
        return WeatherModel(cityName: place, temperature: temp, climateStatus: cloudstatus);
        }
        
        return WeatherModel.empty(message:'city not found');
      } on SocketException catch(_){
          return WeatherModel.empty(message: 'check internet connection');
      }
      
       catch(e){
        return WeatherModel.empty(message: 'something is wrong');
      }
  }

  int  convertKelvintoCelcius(double value){
        double celcius = value-273.15;
        return celcius.round();
   }


}

