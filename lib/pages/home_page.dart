import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/model/weathermodel.dart';
import 'package:weatherapp/service/homeService.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var weatherData;
  final inputdata = TextEditingController();
  String? message;

  void sendingDataToApi() {
    setState(() {
      weatherData = HomeService().getWeatherDataUsingCity(inputdata.text);
      inputdata.clear();
    });
  }

  String getImageByCloudStatus(String cloudstatus){
    switch(cloudstatus.toLowerCase()){
     case 'clouds':
     case 'mist':
     case 'smoke':
     case 'haze':
     case 'dust':
     case 'fog':
        return 'images/cloudy.json';
     case 'rain':
     case 'drizzle':
     case 'shower rain':
       return 'images/rainy.json';
     case 'thunderstorm':
        return 'images/thunder.json';
     case 'clear':
         return 'images/sunny.json';
     default:
        return 'images/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: inputdata,

                        textAlign: TextAlign.center,

                        decoration: InputDecoration(
                          hintText: 'Enter your city',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendingDataToApi();
                      },
                      icon: Icon(Icons.search, size: 35),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),

                child: FutureBuilder<WeatherModel>(
                  future: weatherData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        WeatherModel data = snapshot.data!;
                        message = data.message;

                        if (message != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  message!,
                                  textAlign: TextAlign.center,
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          });
                        } else {
                          return Column(
                            
                            children: [
                            
                              Text(
                                '${data.cityName}',
                                style: TextStyle(fontSize: 25,),
                              ),
                               FittedBox(
                                child: Lottie.asset(getImageByCloudStatus(data.climateStatus!))
                                ),
                                 Text(
                                '${data.temperature}°C',
                                style: TextStyle(fontSize: 25,
                                ),
                              ),
                            ],
                          );
                        }
                        return Text('');
                      } else {
                        return SizedBox.shrink();
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
