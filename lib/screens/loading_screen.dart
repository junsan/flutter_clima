import 'package:flutter/material.dart';
import 'package:flutter_clima/screens/location_screen.dart';
import '../services/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    getData();
  }

  void getData() async {
    http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));
    String data = response.body;
    var decoData = jsonDecode(data);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(weatherData: decoData);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.grey.shade900,
          child: SpinKitWave(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}


