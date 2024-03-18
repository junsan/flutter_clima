import 'package:flutter/material.dart';
import '../services/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

const apiKey = 'a64fb91b80672c38b743d6e407d7621b';

class _LoadingScreenState extends State<LoadingScreen> {

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    longitude = double.parse(location.longitude!.toStringAsFixed(2));
    latitude = double.parse(location.latitude!.toStringAsFixed(2));
    print(longitude);
    print(latitude);
    getData();
  }

  void getData() async {
    http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey'));
    String data = response.body;
    var decoData = jsonDecode(data);

    print(data);

    var weatherId = decoData['weather'][0]['id'];
    var location = decoData['name'];
    var temperature = decoData['main']['temp'];

    print(weatherId);
    print(location);
    print(temperature);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Container(
          color: Colors.blue,
          child: TextButton(
            onPressed: () {

            },
            child: Text('Get Current Location'),
          ),
        ),
      ),
    );
  }
}


