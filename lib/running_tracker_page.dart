import 'package:fitness_tracker_app/running_tracker_log.dart';
import 'package:fitness_tracker_app/db/user_database.dart';
import 'package:fitness_tracker_app/model/running_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';

class RunningTrackerPage extends StatefulWidget {
  static String routeName = '/runningTracker';

  const RunningTrackerPage({super.key});
  @override
  _RunningTrackerPageState createState() => _RunningTrackerPageState();
}

class _RunningTrackerPageState extends State<RunningTrackerPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isRunning = false;

  LocationData? _currentLocation;
  final Location _location = Location();
  final MapController _mapController = MapController();

  late LocationData _previousLocation;
  double _totalDistance = 0.0;

  final List<LatLng> _trailCoordinates = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _checkPermission();
    _listenLocationChanges();
  }

  void _checkPermission() async {
    // checks device location permission
    var locationPermission = await _location.requestPermission();
    if (locationPermission != PermissionStatus.granted) {
      // Handle location permission denied
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
    // calculate the distance based on the coordinates
    double distanceInMeters = Distance().as(
      LengthUnit.Meter,
      LatLng(
        _previousLocation.latitude!,
        _previousLocation.longitude!,
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
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _elapsedTime = _stopwatch.elapsed;
      });
    });
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer.cancel();
  }

  void _stopActivity() async {
    _timer.cancel();
    _stopwatch.stop(); // stop stopwatch
    _elapsedTime = _stopwatch.elapsed; // Store the current elapsed time
    _stopwatch.reset(); // reset stopwatch
    final double distance = _totalDistance; // Store the current total distance
    _totalDistance = 0.0; // Reset total distance
    _trailCoordinates.clear(); // Reset trail coordinates

    if (_totalDistance == 0.0 && _elapsedTime == Duration.zero) {
      // Do nothing
    } else {
      // Create new RunningActivity object
      final activity =
      RunningActivity(distance: distance, duration: _elapsedTime.inSeconds);
      // Call the db and insert activity into the db
      final db = UserDatabase.instance;
      await db.insertActivity(activity);
      // Navigate to Running Tracker Log page
      Navigator.of(context).pushNamed(RunningTrackerLog.routeName);
    }

    // reset current location
    setState(() {
      _currentLocation = null;
    });

    _elapsedTime = Duration.zero; // Reset elapsed time
  }

  void _startTracking() {
    // set isRunning to true
    _isRunning = true;
    // clears the trail coordinates list
    _trailCoordinates.clear();
    _previousLocation = _currentLocation!; // Reset previous location
    _startTimer();
    _updateDistance(); // Update distance when tracking starts
  }
  void _stopTracking() {
    // set isRunning to false
    _isRunning = false;
    _stopTimer(); // stops the timer
  }

  void _updateTrail(LatLng newLocation) {
    // adds the new location coordinates to the list
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
        title: const Text('Running Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: (){
              Navigator.of(context).pushNamed(RunningTrackerLog.routeName);
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
                        builder: (ctx) => const Icon(
                          Icons.location_on,
                          color: Colors.red,
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Distance',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      "${_totalDistance.toStringAsFixed(2)}km",
                      style:
                      const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
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
                  icon: const Icon(Icons.play_arrow),
                  // if isRunning is true then the button will be disabled, else start tracking
                  onPressed: _isRunning ? null : _startTracking,
                  iconSize: 48,
                  color: Colors.green,
                ),
                IconButton(
                  icon: const Icon(Icons.pause),
                  // if isRunning is true then stop tracking, else the button will be disabled
                  onPressed: _isRunning ? _stopTracking : null,
                  iconSize: 48,
                  color: Colors.red,
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: _stopActivity,
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
