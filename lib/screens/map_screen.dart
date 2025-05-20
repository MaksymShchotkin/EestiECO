import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EstoniaMapScreen extends StatefulWidget {
  @override
  _EstoniaMapScreenState createState() => _EstoniaMapScreenState();
}

class _EstoniaMapScreenState extends State<EstoniaMapScreen> {
  final MapController _mapController = MapController();
  List<Polygon> _polygons = [];

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
  }

  Future<void> _loadGeoJson() async {
    final String geojsonStr =
    await rootBundle.loadString('assets/estonia_polygon_map.json');
    final Map<String, dynamic> geojson = json.decode(geojsonStr);

    List<Polygon> polygons = [];

    for (var feature in geojson['features']) {
      final coords = feature['geometry']['coordinates'][0];
      List<LatLng> points = coords
          .map<LatLng>((pt) => LatLng(pt[1].toDouble(), pt[0].toDouble()))
          .toList();

      polygons.add(
        Polygon(
          points: points,
          borderColor: Colors.black,
          color: Colors.blue.withOpacity(0.4),
          borderStrokeWidth: 1.0,
        ),
      );
    }

    setState(() {
      _polygons = polygons;
    });
  }

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
              PolygonLayer(polygons: _polygons),
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
