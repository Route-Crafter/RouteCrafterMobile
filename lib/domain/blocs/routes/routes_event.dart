part of 'routes_bloc.dart';

@immutable
sealed class RoutesEvent {}

final class InitBloc extends RoutesEvent {
  
}

final class LoadMapInitialization extends RoutesEvent {
  final GoogleMapController controller;
  LoadMapInitialization({required this.controller});
}

final class UpdateMapPosition extends RoutesEvent {
  final LatLng position;
  UpdateMapPosition({required this.position});
}

final class SelectRoute extends RoutesEvent {
  final TransportRoute? route;
  final Color mainColor;
  SelectRoute(
    this.route,
    this.mainColor
  );
}

final class SelectRouteExecution extends RoutesEvent {
  final RouteExecution? routeExecution;
  SelectRouteExecution(this.routeExecution);
}