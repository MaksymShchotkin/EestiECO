import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EstoniaMapScreen extends StatefulWidget {
  @override
  _EstoniaMapScreenState createState() => _EstoniaMapScreenState();
}

class _EstoniaMapScreenState extends State<EstoniaMapScreen> {
  final MapController _mapController = MapController();

  double _currentZoom = 7.5;

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(1.0, 18.0);
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(1.0, 18.0);
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(58.5953, 25.0136),
              zoom: _currentZoom,
              minZoom: 3,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
          Positioned(
            right: 10,
            bottom: 50,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  onPressed: _zoomIn,
                  child: Icon(Icons.zoom_in),
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _zoomOut,
                  child: Icon(Icons.zoom_out),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
