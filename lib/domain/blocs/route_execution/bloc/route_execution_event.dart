part of 'route_execution_bloc.dart';

@immutable
sealed class RouteExecutionEvent {}

class InitBloc extends RouteExecutionEvent {
  final TransportRoute route;
  final RouteExecution routeExecution;
  InitBloc({
    required this.route,
    required this.routeExecution
  });
}

class InitRouteExecutionProccess extends RouteExecutionEvent {
  final GoogleMapController mapController;
  InitRouteExecutionProccess({required this.mapController});
}

class _UpdateMap extends RouteExecutionEvent {
  final DirectionedWayPoint newPoint;
  _UpdateMap({required this.newPoint});
}

class EndRouteExecutionProccess extends RouteExecutionEvent {
  
}