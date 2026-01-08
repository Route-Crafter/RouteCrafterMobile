import 'package:flutter/services.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';

abstract class LocationServices {
  Future<void> startService(Function(DirectionedWayPoint) callBack);
  Future<void> endService();
}

class LocationServicesImpl implements LocationServices{

  static const _channel = MethodChannel("com.jhoncke.routecrafter/location");
  
  @override
  Future<void> startService(Function(DirectionedWayPoint p1) callBack) async {
    _initListener(callBack);
    await _channel.invokeMethod('startService');
  }

  void _initListener(Function(DirectionedWayPoint) onLocation){
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'locationUpdate'){
        final args = Map<String, dynamic>.from(call.arguments);
        onLocation(DirectionedWayPoint(
          lat: args['lat'],
          lon: args['lon'],
          speed: args['vel'],
          bearing: args['bearing']
        ));
      }
    });
  }

  @override
  Future<void> endService() async {
    await _channel.invokeMethod('stopService');
  }

}