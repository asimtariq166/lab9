import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'locationscreen.dart';
import 'network.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

var jasonDecodeData;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var perm;
  var longitude;
  var lattitude;
  void getCurrentPosition() async {
    perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = Geolocator.requestPermission();

      if (perm == LocationPermission.denied) {
        print('Permission denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    lattitude = position.latitude;
    longitude = position.longitude;
    networkhelper helper = networkhelper(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?units=metric&lat=$lattitude&lon=$longitude&appid=a67cbb0bb50f199ee71118ac40c1e561'));

    jasonDecodeData = await helper.getdata();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(locationWeather: jasonDecodeData);
    }));

    print(position.latitude);
    print(position.longitude);
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SpinKitPianoWave(
                  color: Color.fromARGB(255, 91, 22, 194),
                  size: 40,
                ),
              ),
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    getCurrentPosition();
                  });
                },
                child: Text("Get Location"),
              ),
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationScreen(
                                  locationWeather: jasonDecodeData,
                                )));
                  },
                  child: Text("Screen 2")),
            ]),
      ),
    );
  }
}
