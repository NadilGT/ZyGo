import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String baseUrl;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  String? _lastUrl;
  
  // Stream controllers for broadcasting events
  final _locationController = StreamController<LocationUpdate>.broadcast();
  final _statusController = StreamController<DriverStatus>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<LocationUpdate> get locationStream => _locationController.stream;
  Stream<DriverStatus> get statusStream => _statusController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  bool get isConnected => _isConnected;

  WebSocketService({this.baseUrl = 'ws://10.72.25.75:3000'});

  /// Connect as a Driver
  Future<void> connectAsDriver(String driverId, {String? token}) async {
    final url = '$baseUrl/ws/driver?driver_id=$driverId${token != null ? '&token=$token' : ''}';
    await _connect(url);
  }

  /// Connect as a Rider
  Future<void> connectAsRider(String riderId, {String? token}) async {
    final url = '$baseUrl/ws/rider?rider_id=$riderId${token != null ? '&token=$token' : ''}';
    await _connect(url);
  }

  Future<void> _connect(String url) async {
    _lastUrl = url;
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      
      await _channel!.ready;
      _isConnected = true;
      _connectionController.add(true);
      
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );
      
      print('WebSocket connected: $url');
    } catch (e) {
      print('WebSocket connection error: $e');
      _isConnected = false;
      _connectionController.add(false);
      _scheduleReconnect(url);
    }
  }

  void _onMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final type = data['type'];
      final payload = data['payload'];

      switch (type) {
        case 'location_update':
          _locationController.add(LocationUpdate.fromJson(payload));
          break;
        case 'driver_status':
          _statusController.add(DriverStatus.fromJson(payload));
          break;
        case 'connected':
          print('Connected: ${payload['message']}');
          break;
        default:
          print('Unknown message type: $type');
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  void _onError(error) {
    print('WebSocket error: $error');
    _isConnected = false;
    _connectionController.add(false);
  }

  void _onDone() {
    print('WebSocket connection closed');
    _isConnected = false;
    _connectionController.add(false);
    if (_lastUrl != null) {
      _scheduleReconnect(_lastUrl!);
    }
  }

  void _scheduleReconnect(String url) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      print('Attempting to reconnect...');
      _connect(url);
    });
  }

  /// Send location update (for drivers)
  void sendLocation({
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
  }) {
    if (!_isConnected) return;
    
    final data = jsonEncode({
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading ?? 0,
      'speed': speed ?? 0,
    });
    
    _channel?.sink.add(data);
  }

  /// Subscribe to a driver's location (for riders)
  void subscribeToDriver(String driverId) {
    if (!_isConnected) return;
    
    final data = jsonEncode({
      'action': 'subscribe',
      'driver_id': driverId,
    });
    
    _channel?.sink.add(data);
  }

  /// Unsubscribe from a driver (for riders)
  void unsubscribeFromDriver(String driverId) {
    if (!_isConnected) return;
    
    final data = jsonEncode({
      'action': 'unsubscribe',
      'driver_id': driverId,
    });
    
    _channel?.sink.add(data);
  }

  /// Disconnect
  void disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _isConnected = false;
    _connectionController.add(false);
  }

  void dispose() {
    disconnect();
    _locationController.close();
    _statusController.close();
    _connectionController.close();
  }
}

// Models
class LocationUpdate {
  final String driverId;
  final double latitude;
  final double longitude;
  final double heading;
  final double speed;
  final int timestamp;

  LocationUpdate({
    required this.driverId,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.speed,
    required this.timestamp,
  });

  factory LocationUpdate.fromJson(Map<String, dynamic> json) {
    return LocationUpdate(
      driverId: json['driver_id'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      heading: (json['heading'] ?? 0).toDouble(),
      speed: (json['speed'] ?? 0).toDouble(),
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading,
      'speed': speed,
      'timestamp': timestamp,
    };
  }
}

class DriverStatus {
  final String driverId;
  final bool isOnline;
  final String? lastSeen;

  DriverStatus({
    required this.driverId,
    required this.isOnline,
    this.lastSeen,
  });

  factory DriverStatus.fromJson(Map<String, dynamic> json) {
    return DriverStatus(
      driverId: json['driver_id'] ?? '',
      isOnline: json['is_online'] ?? false,
      lastSeen: json['last_seen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'is_online': isOnline,
      'last_seen': lastSeen,
    };
  }
}
