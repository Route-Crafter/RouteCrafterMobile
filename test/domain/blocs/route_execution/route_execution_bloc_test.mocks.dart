import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:routes_mobile/data/services/route_executions_services.dart';
import 'package:routes_mobile/domain/entities/places/place_info.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';
import 'package:routes_mobile/utils/geolocation.dart';

class MockGoogleMapController extends Mock implements GoogleMapController {}

class SimpleGoogleMapController extends Fake implements GoogleMapController {
  @override
  Future<void> animateCamera(CameraUpdate cameraUpdate, {Duration? duration}) async {}
}

class FakeGeolocation implements Geolocation {
  Function(DirectionedWayPoint)? _onChanged;
  WayPoint? current;

  FakeGeolocation({this.current});

  @override
  Future<WayPoint?> getCurrentPosition() async => current;

  @override
  Future<void> addOnChanged(Function(DirectionedWayPoint) onChanged) async {
    _onChanged = onChanged;
  }

  void trigger(DirectionedWayPoint p) {
    if (_onChanged != null) _onChanged!(p);
  }

  @override
  Future<void> stopOnChanged() async {}

  @override
  Future<PlaceInfo?> getPlaceInfoFromLocation({LatLng? location}) async => null;
}

class FakeRouteExecutionsServices implements RouteExecutionsServices {
  @override
  Future<RouteExecution> createExecution({required String licensePlate, required DateTime initTime, required String routeId}) {
    throw UnimplementedError();
  }

  @override
  Future<List<RouteExecution>> getExecutionsByRouteId(String id) async => [];

  @override
  Future<RouteExecution> updateExecution({required DateTime endTime, required List<WayPoint> wayPoints, required int routeExecutionId}) async {
    return RouteExecution(
      id: routeExecutionId,
      licensePlate: 'LP',
      initTime: DateTime.now(),
      endTime: endTime,
      points: wayPoints,
    );
  }
}

Future<void> waitForCondition(bool Function() cond, {Duration timeout = const Duration(seconds: 2)}) async {
  final end = DateTime.now().add(timeout);
  while (!cond()) {
    if (DateTime.now().isAfter(end)) break;
    await Future.delayed(const Duration(milliseconds: 10));
  }
}