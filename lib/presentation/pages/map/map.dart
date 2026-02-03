import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:zygo/presentation/pages/map/pricing_cubit/pricing_cubit.dart';
import 'package:zygo/presentation/pages/map/pricing_cubit/pricing_state.dart';
import 'package:zygo/services/websocket_service.dart';

import '../../widgets/Animated_driver_marker.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController mapController = MapController();
  LatLng? userLocation;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  LatLng? destination;
  List<LatLng> routePoints = [];
  String? realDuration;
  String? realDistance;
  late final WebSocketService _ws;
  final Map<String, LocationUpdate> _driverLocations = {};

  Future<void> getRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coords = data['routes'][0]['geometry']['coordinates'] as List;
      final duration = data['routes'][0]['duration'] as num; // in seconds
      final distance = data['routes'][0]['distance'] as num; // in meters

      // Convert to LatLng
      final points = coords.map((c) => LatLng(c[1], c[0])).toList();

      // Format distance and duration for display
      final distanceKm = (distance / 1000).toStringAsFixed(1);
      final durationMin = (duration / 60).ceil().toString();

      setState(() {
        routePoints = points;
        realDistance = '$distanceKm km';
        realDuration = '$durationMin min';
      });

      // ignore: use_build_context_synchronously
      context.read<PricingCubit>().getPrice(
        vehicle: 'tuk',
        distance: distanceKm,
        duration: durationMin,
      );

      // Optionally move map to start of route
      if (points.isNotEmpty) mapController.move(points[0], 13);
    }
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final url = Uri.parse('https://photon.komoot.io/api/?q=$query');

    final response = await http.get(
      url,
      headers: {'User-Agent': 'com.example.app'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List features = data['features'];

      setState(() {
        searchResults = features.map((feature) {
          final coords = feature['geometry']['coordinates'];
          final name = feature['properties']['name'] ?? "Unknown";

          return {
            'name': name,
            'lat': coords[1], // latitude
            'lon': coords[0], // longitude
          };
        }).toList();
      });
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
      // Move map to user location
      mapController.move(userLocation!, 15);
    });
  }

  @override
  void dispose() {
    _ws.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _initWebSocket();
  }

  Future<void> _initWebSocket() async {
    _ws = WebSocketService(
      baseUrl:
          'ws://10.72.25.75:3000', // Use your server IP for physical device
    );

    // Listen for location updates
    _ws.locationStream.listen((update) {
      print(
        '📍 Location update received: ${update.driverId} - ${update.latitude}, ${update.longitude}',
      );
      setState(() {
        _driverLocations[update.driverId] = update;
      });
    });

    // Listen for connection status - subscribe AFTER connected
    _ws.connectionStream.listen((connected) {
      print('🔌 WebSocket connected: $connected');
      if (connected) {
        _ws.subscribeToDriver("driver123");
      }
    });

    // Connect as rider (this must happen BEFORE subscribing)
    await _ws.connectAsRider("rider456");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map View")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: userLocation ?? LatLng(0, 0),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png",
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName:
                    "com.zygo.app", // Use your actual package name here
                retinaMode: true,
              ),

              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: Colors.blue,
                      strokeWidth: 5,
                    ),
                  ],
                ),

              if (userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 60,
                      height: 60,
                      point: userLocation!,
                      child: const Icon(
                        Icons.man_2_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    if (destination != null)
                      Marker(
                        point: destination!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ..._driverLocations.entries.map(
                      (e) => Marker(
                        width: 50,
                        height: 50,
                        point: LatLng(e.value.latitude, e.value.longitude),
                        child: AnimatedDriverMarker(
                          point: LatLng(e.value.latitude, e.value.longitude),
                          heading: e
                              .value
                              .heading, // The car will now face the right way!
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(14),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Where are you going?",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      searchLocation(value);
                    },
                  ),
                ),
                if (searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final result = searchResults[index];
                        return ListTile(
                          title: Text(result['name']),
                          onTap: () {
                            final lat = result['lat'];
                            final lon = result['lon'];
                            final dest = LatLng(lat, lon);

                            setState(() {
                              destination = dest;
                              _searchController.text = result['name'];
                              searchResults = [];
                              routePoints = [];
                            });

                            if (userLocation != null) {
                              getRoute(userLocation!, dest); // draw route
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: BlocBuilder<PricingCubit, PricingState>(
              builder: (context, state) {
                if (state is PricingInLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is PricingSuccess) {
                  final priceData = state.data;
                  return _buildPriceBottomCard(priceData);
                }
                if (state is PricingFailure) {
                  return Container(
                    color: Colors.redAccent,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      state.error,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBottomCard(dynamic price) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price.vehicleType.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text("$realDistance • $realDuration"),
                ],
              ),
              Text(
                "${price.currency} ${price.totalFare.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                /* Confirm Booking Logic */
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("CONFIRM ZYGO RIDE"),
            ),
          ),
        ],
      ),
    );
  }
}
