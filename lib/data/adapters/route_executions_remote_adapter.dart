import 'package:routes_mobile/data/adapters/data_formatter.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';

abstract class RouteExecutionsRemoteAdapter{
  List<RouteExecution> getExecutionsFromData(dynamic data);
  Map<String, dynamic> getJsonFromRouteExecutionCreation({
    required String licensePlate,
    required DateTime initTime
  });
  RouteExecution getExecutionFromInitData(dynamic data);
  Map<String, dynamic> getJsonFromRouteExecutionUpdate({
    required String routeId,
    required DateTime endTime,
    required List<WayPoint> points
  });
  RouteExecution getExecutionFromEndData(dynamic data);
}

class RouteExecutionsRemoteAdapterImpl implements RouteExecutionsRemoteAdapter{
  final DataFormatter dataFormatter;

  RouteExecutionsRemoteAdapterImpl({required this.dataFormatter});

  @override
  List<RouteExecution> getExecutionsFromData(data) {
    final list = (data as List).cast<Map<String, dynamic>>();
    return list.map(
      (e) => RouteExecution(
        id: e['id'],
        licensePlate: e['licensePlate'],
        initTime: dataFormatter.getDateFromString(e['initTime'] as String),
        endTime: e['endTime'] != null? dataFormatter.getDateFromString(e['endTime']) : null,
        points: (e['points'] as List).cast<Map<String, dynamic>>()
          .map(
            (wP) => WayPoint(
              lat: (wP['lat'] as num).toDouble(),
              lon: (wP['lon'] as num).toDouble(),
              speed: (wP['speed'] as num).toDouble()
            )
          ).toList()
      )
    ).toList();
  }

  @override
  Map<String, dynamic> getJsonFromRouteExecutionCreation({required String licensePlate, required DateTime initTime}) => {
    'licensePlate': licensePlate,
    'initTime': dataFormatter.getStringFromDate(initTime)
  };

  @override
  RouteExecution getExecutionFromInitData(data) {
    final jsonData = (data as Map).cast<String, dynamic>();
    return RouteExecution(
      id: jsonData['id'],
      licensePlate: jsonData['licensePlate'],
      initTime: dataFormatter.getDateFromString(jsonData['initTime']),
      endTime: null,
      points: []
    );
  }

  @override
  Map<String, dynamic> getJsonFromRouteExecutionUpdate({
    required DateTime endTime,
    required List<WayPoint> points,
    required String routeId
  }) => {
    'endTime': dataFormatter.getStringFromDate(endTime),
    'points': points.map(
      (wP) => {
        'lat': wP.lat,
        'lon': wP.lon,
        'speed': wP.speed
      }
    ).toList(),
    'routeId': routeId
  };
  
  @override
  RouteExecution getExecutionFromEndData(data) {
    final jsonData = (data as Map).cast<String, dynamic>();
    return RouteExecution(
      id: jsonData['id'],
      licensePlate: jsonData['licensePlate'],
      initTime: dataFormatter.getDateFromString( jsonData['initTime'] ),
      endTime: dataFormatter.getDateFromString( jsonData['endTime'] ),
      points: (jsonData['points'] as List).cast<Map<String, dynamic>>()
        .map(
          (wP) => WayPoint(
            lat: wP['lat'],
            lon: wP['lon'],
            speed: wP['speed']
          )
        ).toList()
    );
  }
}