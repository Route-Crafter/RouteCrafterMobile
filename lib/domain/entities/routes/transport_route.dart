import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';

class TransportRoute {
  final String uuid;
  final String name;
  final String description;
  final List<RouteExecution> executions;
  final List<WayPoint> coords;
  TransportRoute({
    required this.uuid,
    required this.name,
    required this.description,
    required this.executions,
    this.coords = const []
  });

  TransportRoute copyWith({
    List<RouteExecution>? executions
  }) => TransportRoute(
    uuid: uuid,
    name: name,
    description: description,
    executions: executions ?? this.executions,
    coords: coords
  );
}