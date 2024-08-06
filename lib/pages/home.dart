import 'package:flutter/material.dart';
import 'package:wether_app/model/wether_data.dart';
import 'package:wether_app/weather_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  ApiData? response;
  bool inProgress = false;
  String message = "Search for the location to get weather data";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: Colors.blueAccent,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _mySearchWidget(),
            const SizedBox(height: 20),
            if (inProgress)
              CircularProgressIndicator()
            else
              Expanded(child: SingleChildScrollView(child: _myWeatherWidget())),
          ],
        ),
      ),
    ));
  }

  Widget _mySearchWidget() {
    return SearchBar(
      hintText: "Search any location",
      onSubmitted: (value) {
        _getWeatherData(value);
      },
    );
  }

  Widget _myWeatherWidget() {
    if (response == null) {
      return Text(message);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            response?.location?.name ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: Image.network(
                "https:${response?.current?.condition?.icon}"
                    .replaceAll("64x64", "128x128"),
                scale: 0.7,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (response?.current?.tempC.toString() ?? "") + " °c",
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                (response?.current?.condition?.text.toString() ?? ""),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: _dataAndTitleWidget("Humidity",
                        response?.current?.humidity?.toString() ?? ""),
                  ),
                  Container(
                      width: 180,
                      decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(10)),
                      child: _dataAndTitleWidget("Wind Speed",
                          "${response?.current?.windKph?.toString() ?? ""} km/h"))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: _dataAndTitleWidget(
                        "UV", response?.current?.uv?.toString() ?? ""),
                  ),
                  Container(
                    width: 180,
                    decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: _dataAndTitleWidget("Percipitation",
                        "${response?.current?.precipMm?.toString() ?? ""} mm"),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: _dataAndTitleWidget("Local Time",
                        response?.location?.localtime?.split(" ").last ?? ""),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: _dataAndTitleWidget("Local Date",
                        response?.location?.localtime?.split(" ").first ?? ""),
                  ),
                ],
              )
            ],
          )
        ],
      );
    }
  }

  Widget _dataAndTitleWidget(String title, String data) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(
            data,
            style: const TextStyle(
              fontSize: 27,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });

    try {
      response = await WeatherApi().getCurrentWeather(location);
    } catch (e) {
      setState(() {
        message = "Failed to get weather ";
        response = null;
      });
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
