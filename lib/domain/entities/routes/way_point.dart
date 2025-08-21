class WayPoint {
  final double lat;
  final double lon;
  final double speed;
  WayPoint({
    required this.lat,
    required this.lon,
    required this.speed
  });
}

class DirectionedWayPoint extends WayPoint {
  final double bearing;
  DirectionedWayPoint({
    required super.lat,
    required super.lon,
    required super.speed,
    required this.bearing
  });
}