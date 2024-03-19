
import 'package:flutter/material.dart';
import 'package:flutter_clima/screens/city_screen.dart';
import 'package:flutter_clima/utilities/constant.dart';
import 'package:flutter_clima/services/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'a64fb91b80672c38b743d6e407d7621b';

class LocationScreen extends StatefulWidget {

  LocationScreen({required this.weatherData});

  final dynamic? weatherData;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weatherModel = WeatherModel();
  var weatherId;
  String? location;
  int? temperature;
  String? weatherIcon;
  String? weatherMessage;

  @override
  void initState() {
    super.initState();
    getUI(widget.weatherData);
  }

  void getUI(uiData) {
    setState(() {
      weatherId = uiData['weather'][0]['id'];
      location = uiData['name'];
      double temp = uiData['main']['temp'];
      weatherIcon = weatherModel.getWeatherIcon(weatherId);
      temperature = temp.toInt();
      weatherMessage = weatherModel.getMessage(temperature!);
    });
  }

  Future<dynamic> getCityNameWeather(String cityName) async {
    http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));
    String data = response.body;
    return jsonDecode(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                     onPressed: () async {
                       var cityName = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                         return CityScreen();
                       }));
                       if(cityName != null) {
                         var weatherData = await getCityNameWeather(cityName);
                         getUI(weatherData);
                       }
                     },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon!,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $location!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
