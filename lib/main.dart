import 'package:flutter/material.dart';
import 'package:flutter_maps_testing/chartScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'mapScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App for Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter App for Map Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String LatLong = "";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'The selected Location is: $LatLong'
              ),
              Text(
                'This app is for demonstrating the map and the selected location.',
                textAlign: TextAlign.center,
              ),
              Container(
                height: 20,
              ),
              RaisedButton(
                child: Text('Ask for permission'),
                onPressed: () {
                  doLocationPermissionAsk();
                },
              ),
              RaisedButton(
                child: Text('Show me maps'),
                onPressed: () async {
                  CameraPosition cameraPosition = await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MapScreen()));
                  setState(() {
                    LatLong = cameraPosition.target.latitude.toString() + " : " + cameraPosition.target.longitude.toString();
                  });
                },
              ),
              RaisedButton(
                child: Text('Show me charts'),
                onPressed: (){
                  List<charts.Series<dynamic, String>> theList = List();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SimpleBarChart(_createSampleData())));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
        )
    ];
  }

  Future doLocationPermissionAsk() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
  }
}
