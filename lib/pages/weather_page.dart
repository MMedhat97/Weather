import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/Services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService('426ca13d22aef79f026950b17f08d681');
  Weather? _weather;


  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName =await  _weatherService.getCurrentCity();

    //get weather for city
    try{
      final weather=await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any errors
    catch(e){
      if (kDebugMode) {
        print(e);
      }
    }

  }


  //weather animation
  String getWeatherAnimation(String? mainCondition){
    if(mainCondition==null)return 'assets/sunny.json'; //default
    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';


      case 'thunder storm':
        return 'assets/thunder.json';

      case 'clear':
        return 'assets/sunny.json';

      default:
        return 'assets/sunny.json';

    }
  }




  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather in startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName?? "loading city...",style: const TextStyle(color: Colors.orange,fontSize: 35),),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),


            //temprature
            Text('${_weather?.temprature.round()}°C',style: const TextStyle(color: Colors.white,fontSize: 30),),

            //weather condition
            Text(_weather?.mainCondition ??"",style: const TextStyle(color: Colors.orangeAccent,fontSize: 20),),


          ],
        ),
      ),
    );


  }
}
