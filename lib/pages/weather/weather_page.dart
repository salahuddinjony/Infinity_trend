import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:login_page/pages/weather/bloc/weather_bloc_bloc.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 18) {
      return "Good Afternoon";
    } else if (hour >= 18 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  Widget getWeatherIcon(int code, bool isDarkMode) {
    double iconSize = 200.0; // Set the desired size of the icon

    switch (code) {
      case >= 200 && < 300:
        return Center(
          child: Image.asset(
            'assets/images/1.png',
            color: isDarkMode ? Colors.white : null,
            width: iconSize,
            height: iconSize,
          ),
        );
      case >= 300 && < 400:
        return Center(
          child: Image.asset(
            'assets/images/2.png',
            color: isDarkMode ? Colors.white : null,
            width: iconSize,
            height: iconSize,
          ),
        );
      case >= 500 && < 600:
        return Center(
          child: Image.asset(
            'assets/images/3.png',
            color: isDarkMode ? Colors.white : null,
            width: iconSize,
            height: iconSize,
          ),
        );
      case >= 600 && < 700:
        return Center(
          child: Image.asset(
            'assets/images/4.png',
            color: isDarkMode ? Colors.white : null,
            width: iconSize,
            height: iconSize,
          ),
        );
      case >= 700 && < 800:
        return Center(
          child: Image.asset(
            'assets/images/5.png',
            color: isDarkMode ? Colors.white : null,
            width: iconSize,
            height: iconSize,
          ),
        );
      case == 800:
        return Center(
          child: Image.asset(
            'assets/images/6.png',
            color: isDarkMode ? Colors.white : null,
            width: iconSize,
            height: iconSize,
          ),
        );
      case > 800 && <= 804:
        return Center(
          child: Image.asset(
            'assets/images/7.png',
            color: isDarkMode ? Colors.white : null,
            width: iconSize,
            height: iconSize,
          ),
        );
      default:
        return Center(
          child: Image.asset(
            'assets/images/7.png',
            color: isDarkMode ? Colors.white : null,
            width: iconSize,
            height: iconSize,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(3, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? Colors.teal : Colors.blue,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-3, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? Colors.teal :  Colors.blue,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -1.2),
              child: Container(
                height: 300,
                width: 600,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] :  Colors.blue,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
            BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
              builder: (context, state) {
                if (state is WeatherBlocSuccess) {
                  return SingleChildScrollView( // ✅ Fix: Allow scrolling if content overflows
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📍 ${state.weather.areaName}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Use the dynamic greeting instead of "Good Morning"
                        Text(
                          getGreeting(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        getWeatherIcon(state.weather.weatherConditionCode!, isDarkMode),
                        Center(
                          child: Text(
                            '${state.weather.temperature!.celsius!.round()}°C',
                            style: const TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            state.weather.weatherMain!.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Text(
                            DateFormat.jm().format(state.weather.date!), // Shows only time
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            weatherDetail('Sunrise', 'assets/images/11.png', DateFormat('HH:mm').format(state.weather.sunrise!)),
                            weatherDetail('Sunset', 'assets/images/12.png', DateFormat('HH:mm').format(state.weather.sunset!)),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Divider(color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            weatherDetail('Temp Max', 'assets/images/13.png', state.weather.tempMax!.celsius!.round(), suffix: "°C"),
                            weatherDetail('Temp Min', 'assets/images/14.png', state.weather.tempMin!.celsius!.round(), suffix: "°C"),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(); // Placeholder for loading state
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget weatherDetail(String title, String imagePath, dynamic value, {String suffix = ""}) {
    return Row(
      children: [
        Image.asset(imagePath, scale: 8),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              "$value$suffix",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}