import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';

class RunningTrackerPage extends StatefulWidget {
  static String routeName = '/runningTracker';
  @override
  _RunningTrackerPageState createState() => _RunningTrackerPageState();
}

class _RunningTrackerPageState extends State<RunningTrackerPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isRunning = false;

  LocationData? _currentLocation;
  Location _location = Location();
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _checkPermission();
    _listenLocationChanges();
  }

  void _checkPermission() async {
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        // Handle permission denied
      }
    }
    if (permissionStatus == PermissionStatus.granted) {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
      _moveToCurrentLocation();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _listenLocationChanges() {
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
    });
  }

  void _moveToCurrentLocation() {
    if (_currentLocation != null) {
      double? latitude = _currentLocation!.latitude;
      double? longitude = _currentLocation!.longitude;
      if (latitude != null && longitude != null) {
        _mapController.move(LatLng(latitude, longitude), 15.0);
      }
    }
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _elapsedTime = _stopwatch.elapsed;
      });
    });
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer.cancel();
    setState(() {
      _elapsedTime = _stopwatch.elapsed;
    });
  }

  void _resetTimer() {
    _stopwatch.reset();
    setState(() {
      _elapsedTime = Duration.zero;
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        '${_elapsedTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
        '${_elapsedTime.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Running Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(0, 0),
                  zoom: 13.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: _currentLocation != null
                        ? [
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: LatLng(
                          _currentLocation!.latitude!,
                          _currentLocation!.longitude!,
                        ),
                        builder: (ctx) => Container(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ]
                        : [],
                  ),
                ],
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Distance',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      '0.0 km',
                      style:
                      TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Time Elapsed',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      formattedTime,
                      style:
                      const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    if (!_isRunning) {
                      _startTimer();
                      setState(() {
                        _isRunning = true;
                      });
                    }
                  },
                  icon: Icon(Icons.play_arrow),
                  iconSize: 48,
                ),
                IconButton(
                  onPressed: () {
                    if (_isRunning) {
                      _stopTimer();
                      setState(() {
                        _isRunning = false;
                      });
                    }
                  },
                  icon: Icon(Icons.stop),
                  iconSize: 48,
                ),
                IconButton(
                  onPressed: () {
                    if (!_isRunning) {
                      _resetTimer();
                    }
                  },
                  icon: Icon(Icons.refresh),
                  iconSize: 48,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
