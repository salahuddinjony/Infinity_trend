import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login_page/pages/bazar%20pages/home_screen.dart';
import 'package:login_page/pages/weather/bloc/weather_bloc_bloc.dart';
import 'package:login_page/auth/main_page.dart';
import 'package:login_page/data/notifiers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
          ),
          home: FutureBuilder(
            future: _determinePosition(),
            builder: (context, snap) {
              if (snap.hasData) {
                return BlocProvider<WeatherBlocBloc>(
                  create: (context) => WeatherBlocBloc()..add(
                    FetchWeather(snap.data as Position)
                  ),
                  child: const MainPage(),
                );
              } else if (snap.hasError) {
                return Scaffold(
                  body: Center(child: Text(snap.error.toString())),
                );
              } else {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            }
          ),
        );
      },
    );
  }
}

/// Determine the current position of the device.
/// When the location services are not enabled or permissions
/// are denied, the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}