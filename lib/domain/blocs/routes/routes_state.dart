part of 'routes_bloc.dart';

@immutable
sealed class RoutesState {}

final class RoutesInitial extends RoutesState {}

final class NoValue {

}

class OnRoutesMap extends RoutesState {
  final PlaceInfo place;
  final Zone? city;
  final List<TransportRoute> routes;
  final TransportRoute? selectedRoute;
  final RouteExecution? selectedExecution;
  final List<Polyline> routePolylines;
  final GoogleMapController? mapController;
  final Marker devicePosition;
  final bool loadingRoutes;
  OnRoutesMap({
    required this.place,
    this.city,
    this.routes = const [],
    this.selectedRoute,
    this.selectedExecution,
    this.routePolylines = const [],
    this.mapController,
    required this.devicePosition,
    this.loadingRoutes = false
  });
  
  OnRoutesMap copyWith({
    PlaceInfo? place,
    Zone? city,
    List<TransportRoute>? routes,
    TransportRoute? selectedRoute,
    Object? selectedExecution,
    List<Polyline>? routePolylines,
    GoogleMapController? mapController,
    Marker? devicePosition,
    bool? loadingRoutes
  }) => OnRoutesMap(
    place: place ?? this.place,
    city: city ?? this.city,
    routes: routes ?? this.routes,
    selectedRoute: selectedRoute ?? this.selectedRoute,
    selectedExecution: selectedExecution is NoValue? null:
      (selectedExecution as RouteExecution?) ?? this.selectedExecution ,
    routePolylines: routePolylines ?? this.routePolylines,
    mapController: mapController ?? this.mapController,
    devicePosition: devicePosition ?? this.devicePosition,
    loadingRoutes: loadingRoutes ?? this.loadingRoutes
  );
}