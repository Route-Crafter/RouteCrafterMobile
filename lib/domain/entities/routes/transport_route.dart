import 'package:routes_mobile/domain/entities/routes/route_execution.dart';

class TransportRoute {
  final String uuid;
  final String name;
  final String description;
  final List<RouteExecution> executions;
  TransportRoute({
    required this.uuid,
    required this.name,
    required this.description,
    required this.executions
  });

  TransportRoute copyWith({
    List<RouteExecution>? executions
  }) => TransportRoute(
    uuid: uuid,
    name: name,
    description: description,
    executions: executions ?? this.executions
  );
}