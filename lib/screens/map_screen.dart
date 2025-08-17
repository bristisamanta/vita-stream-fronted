import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  String _filter = "All";
  bool _offline = false;

  List<Map<String, dynamic>> waterSources = [
    {
      "name": "Community Well A",
      "lat": 26.1883,
      "lng": 91.6918,
      "status": "safe",
      "ph": 7.1,
      "tds": 350,
      "lastUpdated": "2 min ago"
    },
    {
      "name": "Hand Pump B",
      "lat": 26.1901,
      "lng": 91.6930,
      "status": "unsafe",
      "ph": 5.8,
      "tds": 780,
      "lastUpdated": "5 min ago"
    },
    {
      "name": "Tank C",
      "lat": 26.1915,
      "lng": 91.6922,
      "status": "unknown",
      "ph": null,
      "tds": null,
      "lastUpdated": "N/A"
    }
  ];

  @override
  void initState() {
    super.initState();
    _simulateLiveUpdates();
  }

  void _simulateLiveUpdates() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        waterSources[0]["tds"] = 320; // fake update
        waterSources[0]["lastUpdated"] = "Just now";
      });
    });
  }

  Color _getMarkerColor(String status) {
    switch (status) {
      case "safe":
        return Colors.green;
      case "unsafe":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Set<Marker> _buildMarkers() {
    return waterSources
        .where(
            (src) => _filter == "All" || src["status"] == _filter.toLowerCase())
        .map((src) {
      return Marker(
        markerId: MarkerId(src["name"]),
        position: LatLng(src["lat"], src["lng"]),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          src["status"] == "safe"
              ? BitmapDescriptor.hueGreen
              : src["status"] == "unsafe"
                  ? BitmapDescriptor.hueRed
                  : BitmapDescriptor.hueOrange,
        ),
        onTap: () => _showSourceDetails(src),
      );
    }).toSet();
  }

  Future<void> _showSourceDetails(Map<String, dynamic> src) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(src["name"],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Status: ${src["status"].toUpperCase()}",
                  style: TextStyle(
                      color: _getMarkerColor(src["status"]),
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("pH: ${src["ph"] ?? 'N/A'}"),
              Text("TDS: ${src["tds"] ?? 'N/A'} ppm"),
              Text("Last Updated: ${src["lastUpdated"]}"),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                label: const Text("Navigate"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  final url =
                      "https://www.google.com/maps/dir/?api=1&destination=${src["lat"]},${src["lng"]}";
                  launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<Position> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _offline = true);
        return Future.error('Location services disabled');
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _offline = true);
          return Future.error('Location permissions denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _offline = true);
        return Future.error('Location permanently denied');
      }
      setState(() => _offline = false);
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      setState(() => _offline = true);
      rethrow;
    }
  }

  void _recenterMap() async {
    Position pos = await _getCurrentLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(26.1883, 91.6918),
            zoom: 14,
          ),
          markers: _buildMarkers(),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        if (_offline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(8),
              child: const Text(
                "⚠ Offline: No location or data available",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: _recenterMap,
            backgroundColor: Colors.teal,
            child: const Icon(Icons.my_location),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: _filter,
              underline: const SizedBox(),
              onChanged: (value) => setState(() => _filter = value!),
              items: ["All", "Safe", "Unsafe", "Unknown"]
                  .map((f) =>
                      DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}
