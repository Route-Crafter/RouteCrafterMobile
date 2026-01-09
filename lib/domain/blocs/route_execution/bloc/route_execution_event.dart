part of 'route_execution_bloc.dart';

@immutable
sealed class RouteExecutionEvent {}

class StartBloc extends RouteExecutionEvent {
  final TransportRoute route;
  final RouteExecution routeExecution;
  StartBloc({
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