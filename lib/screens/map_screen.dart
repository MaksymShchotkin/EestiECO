import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class EstoniaMapScreen extends StatefulWidget {
  @override
  _EstoniaMapScreenState createState() => _EstoniaMapScreenState();
}

class _EstoniaMapScreenState extends State<EstoniaMapScreen> {
  final MapController _mapController = MapController();
  List<Polygon> _polygons = [];
  double _currentZoom = 7.5;

  final List<Map<String, dynamic>> _cities = [
    {'id': 'tallinn', 'name': 'Tallinn, Kadaka tee', 'location': LatLng(59.4370, 24.7536), 'latestAQI': null},
    {'id': 'tartu', 'name': 'Tartu', 'location': LatLng(58.3776, 26.7290), 'latestAQI': null},
    {'id': 'narva', 'name': 'Narva', 'location': LatLng(59.3794, 28.1794), 'latestAQI': null},
    {'id': 'parnu', 'name': 'Pärnu', 'location': LatLng(58.3859, 24.4971), 'latestAQI': null},
    {'id': 'viljandi', 'name': 'Viljandi', 'location': LatLng(58.3639, 25.5904), 'latestAQI': null},
  ];

  @override
  void initState() {
    super.initState();
    _loadLatestAQIData();
  }

  Future<void> _loadLatestAQIData() async {
    for (var city in _cities) {
      final snapshot = await FirebaseFirestore.instance
          .collection('air_quality_markers')
          .doc(city['id'])
          .collection('measurements')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final aqi = snapshot.docs.first.data()['aqi'];
        city['latestAQI'] = aqi;
      } else {
        city['latestAQI'] = null;
      }
    }

    // Trigger UI rebuild
    setState(() {});
  }

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

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _showMarkerDetails(BuildContext context, String cityId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('air_quality_markers')
        .doc(cityId)
        .collection('measurements')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    final measurements = snapshot.docs.map((doc) => doc.data()).toList();

    // Wait for modal to close
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MarkerDetailSlider(
        cityId: cityId,
        measurements: measurements,
      ),
    );

    // Refresh AQI data after modal is closed
    await _loadLatestAQIData();
  }


  Color getAQIColor(int aqi) {
    if (aqi < 50) return Colors.green;
    if (aqi < 100) return Colors.yellow;
    if (aqi < 150) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFE8FFE6),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('EestiECO',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logout),
              onTap: () => _logout(context) ,
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: Localizations.localeOf(context),
                  items: const [
                    DropdownMenuItem(value: Locale('en'), child: Text('English')),
                    DropdownMenuItem(value: Locale('uk'), child: Text('Українська')),
                  ],
                  onChanged: (Locale? locale) {
                    if (locale != null) {
                      MyAppWrapper.setLocale(context, locale);
                    }
                  },
                ),
              ),
            ),

          ],
        ),
      ),
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
              MarkerLayer(
                markers: _cities.map((city) {
                  final int aqi = city['latestAQI'] ?? 0;
                  return Marker(
                    width: 30.0,
                    height: 30.0,
                    point: city['location'],
                    child: GestureDetector(
                      onTap: () => _showMarkerDetails(context, city['id']),
                      child: Container(
                        decoration: BoxDecoration(
                          color: getAQIColor(aqi),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            city['latestAQI']?.toString() ?? '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Better contrast
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _zoomOut,
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarkerDetailSlider extends StatefulWidget {
  final String cityId;
  final List<Map<String, dynamic>> measurements;

  const MarkerDetailSlider({required this.cityId, required this.measurements});

  @override
  _MarkerDetailSliderState createState() => _MarkerDetailSliderState();
}

class _MarkerDetailSliderState extends State<MarkerDetailSlider> {
  final _formKey = GlobalKey<FormState>();
  final _aqiController = TextEditingController();

  Future<void> _submitData() async {
    final aqi = int.tryParse(_aqiController.text);
    if (aqi == null || aqi < 0 || aqi > 500) return;

    await FirebaseFirestore.instance
        .collection('air_quality_markers')
        .doc(widget.cityId)
        .collection('measurements')
        .add({
      'aqi': aqi,
      'timestamp': Timestamp.now(),
    });

    Navigator.pop(context); // closes modal
  }

  Color getAQIColor(int aqi) {
    if (aqi < 50) return Colors.green;
    if (aqi < 100) return Colors.yellow;
    if (aqi < 150) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.enterMeasurement, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _aqiController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.polutionlvl),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(AppLocalizations.of(context)!.submit),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              const SizedBox(height: 20),
              const Divider(),
              Text(AppLocalizations.of(context)!.history),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.measurements.map((data) {
                  final int aqi = data['aqi'] ?? 0;
                  return Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: getAQIColor(aqi),
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        aqi.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
