import 'package:fitness_tracker_app/running_tracker_log.dart';
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

  late LocationData _previousLocation;
  double _totalDistance = 0.0;

  List<LatLng> _trailCoordinates = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _checkPermission();
    _listenLocationChanges();
  }

  void _checkPermission() async {
    var locationPermission = await _location.requestPermission();
    if (locationPermission != PermissionStatus.granted) {
      // Handle location permission denied
    }
  }

  void _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
    } catch (e) {
      // Handle location error
    }
  }

  void _listenLocationChanges() {
    _location.onLocationChanged.listen((LocationData? locationData) {
      setState(() {
        _currentLocation = locationData;
        _moveToCurrentLocation();
        if (_isRunning && _currentLocation != null) {
          if (_previousLocation != null) {
            _updateDistance();
          }
          _previousLocation = _currentLocation!;
          _updateTrail(LatLng(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
          ));
        }
      });
    });
  }

  void _moveToCurrentLocation() {
    if (_currentLocation != null) {
      double latitude = _currentLocation!.latitude!;
      double longitude = _currentLocation!.longitude!;
      _mapController.move(LatLng(latitude, longitude), 15.0);
    }
  }

  void _updateDistance() {
    double distanceInMeters = Distance().as(
      LengthUnit.Meter,
      LatLng(
        _previousLocation!.latitude!,
        _previousLocation!.longitude!,
      ),
      LatLng(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      ),
    );
    _totalDistance += distanceInMeters / 1000; // Convert to kilometers
    _previousLocation = _currentLocation!;
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
  }

  void _resetTimer() {
    _stopwatch.reset();
    setState(() {
      _elapsedTime = Duration.zero;
      _totalDistance = 0.0; // Reset total distance
      _trailCoordinates.clear(); // Reset trail coordinates
    });
  }

  void _startTracking() {
    _isRunning = true;
    _trailCoordinates.clear();
    _previousLocation = _currentLocation!; // Reset previous location
    _startTimer();
    _updateDistance(); // Update distance when tracking starts
  }
  void _stopTracking() {
    _isRunning = false;
    _stopTimer();
  }

  void _updateTrail(LatLng newLocation) {
    setState(() {
      _trailCoordinates.add(newLocation);
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
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RunningTrackerLog()),
            );
            }
          ),
        ],
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
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                        points: _trailCoordinates,
                        color: Colors.blue,
                        strokeWidth: 3.0,
                      ),
                    ],
                  ),
                  MarkerLayerOptions(
                    markers: _currentLocation != null
                        ? [
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: _currentLocation != null
                            ? LatLng(
                          _currentLocation!.latitude!,
                          _currentLocation!.longitude!,
                        )
                            : LatLng(0, 0),
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
                      "${_totalDistance.toStringAsFixed(2)}km",
                      style:
                      TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
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
                  icon: Icon(Icons.play_arrow),
                  onPressed: _isRunning ? null : _startTracking,
                  iconSize: 48,
                  color: Colors.green,
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: _isRunning ? _stopTracking : null,
                  iconSize: 48,
                  color: Colors.red,
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _resetTimer,
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
