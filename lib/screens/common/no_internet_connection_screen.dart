import 'package:flutter/material.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Oops...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: height * 0.08,
              color: Colors.lightBlue.shade900,
              height: 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: height * 0.38,
            child: Icon(
              Icons.wifi_off,
              size: height * 0.3,
              color: Colors.lightBlue.shade900,
            ),
          ),
          Text(
            "Slow or No Internet Connection",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: height * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              "You are not connected to the internet. Make sure Wi-Fi/Data is on, Airplane mode is off and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height * 0.035,
                color: Colors.lightBlue.shade900,
                height: 0.9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
