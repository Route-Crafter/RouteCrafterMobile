part of 'route_execution_bloc.dart';

@immutable
sealed class RouteExecutionState {}

final class RouteExecutionInitial extends RouteExecutionState {}

enum RouteExecutionStatus{
  onProccess,
  loading,
  ended
}

enum MarkerSide {
  left,
  right
}

final class OnRouteExecution extends RouteExecutionState {
  final TransportRoute route;
  final RouteExecution routeExecution;
  final GoogleMapController? mapController;
  final Marker positionMarker;
  final Polyline? routePolyline;
  final List<LatLng> polylinePoints;
  final List<WayPoint> wayPoints;
  final RouteExecutionStatus status;
  final BitmapDescriptor? routeInitImage;
  final BitmapDescriptor? routeEndImage;
  final MarkerSide markerSide;
  OnRouteExecution({
    required this.route,
    required this.routeExecution,
    this.mapController,
    required this.positionMarker,
    this.routePolyline,
    this.polylinePoints = const [],
    this.wayPoints = const [],
    this.status = RouteExecutionStatus.onProccess,
    this.routeInitImage,
    this.routeEndImage,
    this.markerSide = MarkerSide.right
  });

  OnRouteExecution copyWith({
    RouteExecution? routeExecution,
    GoogleMapController? mapController,
    Marker? positionMarker,
    Polyline? routePolyline,
    List<WayPoint>? wayPoints,
    RouteExecutionStatus? status,
    BitmapDescriptor? routeInitImage,
    BitmapDescriptor? routeEndImage,
    MarkerSide? markerSide
  }) => OnRouteExecution(
    route: route,
    routeExecution: routeExecution ?? this.routeExecution,
    mapController: mapController ?? this.mapController,
    positionMarker: positionMarker ?? this.positionMarker,
    routePolyline: routePolyline ?? this.routePolyline,
    wayPoints: wayPoints ?? this.wayPoints,
    status: status ?? this.status,
    routeInitImage: routeInitImage ?? this.routeInitImage,
    routeEndImage: routeEndImage ?? this.routeEndImage,
    markerSide: markerSide ?? this.markerSide
  );
}

final class OnRouteExecutionEnded extends RouteExecutionState{
  final TransportRoute route;
  final RouteExecution endedExecution;
  OnRouteExecutionEnded({
    required this.route,
    required this.endedExecution
  });
}
