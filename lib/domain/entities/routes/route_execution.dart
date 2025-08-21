import 'package:routes_mobile/domain/entities/routes/way_point.dart';

class RouteExecution {
  final int id;
  final String licensePlate;
  final DateTime initTime;
  final DateTime? endTime;
  final List<WayPoint> points;
  const RouteExecution({
    required this.id,
    required this.licensePlate,
    required this.initTime,
    required this.endTime,
    required this.points
  });
}