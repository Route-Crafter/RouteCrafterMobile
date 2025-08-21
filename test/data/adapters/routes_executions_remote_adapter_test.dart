import 'package:flutter_test/flutter_test.dart';
import 'package:routes_mobile/data/adapters/route_executions_remote_adapter.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';

late RouteExecutionsRemoteAdapterImpl routeExecutionsRemoteAdapter;

void main(){
  setUp((){
    routeExecutionsRemoteAdapter = RouteExecutionsRemoteAdapterImpl();
  });

  group('getExecutionsFromData', (){
    test('Cuando todo sale bien', ()async{
      final jsonExecutions = [
        {
          'id': 1,          
          'licensePlate': 'a1',
          'initTime': '2025-01-03 20:01',
          'endTime': '2025-01-03 20:21',
          'wayPoints': [
            {'lat': 1, 'lon': 1, 'vel': 1},
            {'lat': 2, 'lon': 2, 'vel': 2}
          ]
        },
        {
          'id': 2,          
          'licensePlate': 'a2',
          'initTime': '2025-02-03 20:01',
          'endTime': '2025-02-03 20:21',
          'wayPoints': [
            {'lat': 3, 'lon': 3, 'vel': 3},
            {'lat': 4, 'lon': 4, 'vel': 4}
          ]
        }
      ];
      final executions = [
        RouteExecution(
          id: 1,
          licensePlate: 'a1',
          initTime: DateTime(2025, 1, 3, 20, 1),
          endTime: DateTime(2025, 1, 3, 20, 21),
          points: [
            WayPoint(lat: 1, lon: 1, speed: 1),
            WayPoint(lat: 2, lon: 2, speed: 2)
          ]
        ),
        RouteExecution(
          id: 2,
          licensePlate: 'a2',
          initTime: DateTime(2025, 2, 3, 20, 1),
          endTime: DateTime(2025, 2, 3, 20, 21),
          points: [
            WayPoint(lat: 3, lon: 3, speed: 3),
            WayPoint(lat: 4, lon: 4, speed: 4)
          ]
        )
      ];
      final result = routeExecutionsRemoteAdapter.getExecutionsFromData(jsonExecutions);
      expect(result.length, executions.length);
      expect(result.first.id, executions.first.id);
      expect(result.first.initTime.minute, executions.first.initTime.minute);
      expect(result.first.points.length, executions.first.points.length);
      expect(result.first.points.first.lat, executions.first.points.first.lat);
      expect(result.last.licensePlate, executions.last.licensePlate);
      expect(result.last.points.length, executions.last.points.length);
      expect(result.last.points.first.lat, executions.last.points.first.lat);
    });
  });

  group('getJsonFromRouteExecutionCreation', (){
    late String licensePlate;
    late DateTime initTime;
    setUp((){
      licensePlate = 'abc123';
    });
    test('Cuando la fecha tiene horas y minutos', ()async{
      initTime = DateTime(2025, 07, 31, 15, 03);
      final result = routeExecutionsRemoteAdapter.getJsonFromRouteExecutionCreation(
        licensePlate: licensePlate,
        initTime: initTime
      );
      expect(result['licensePlate'], licensePlate);
      expect(result['initTime'], '2025-07-31 15:03');
    });

    test('Cuando la fecha no tiene', ()async{
      initTime = DateTime(2025, 07, 31);
      final result = routeExecutionsRemoteAdapter.getJsonFromRouteExecutionCreation(
        licensePlate: licensePlate,
        initTime: initTime
      );
      expect(result['licensePlate'], licensePlate);
      expect(result['initTime'], '2025-07-31 00:00');
    });
  });

  group('getJsonFromRouteExecutionUpdate', (){
    late DateTime endTime;
    late List<WayPoint> wayPoints;

    setUp((){
      wayPoints = [
        WayPoint(lat: 1.0, lon: 2.0, speed: 3.0),
        WayPoint(lat: 4.0, lon: 5.0, speed: 6.0)
      ];
    });

    test('Cuando la fecha tiene horas y minutos', (){
      endTime = DateTime(2025, 07, 31, 10, 03);
      final result = routeExecutionsRemoteAdapter.getJsonFromRouteExecutionUpdate(
        endTime: endTime,
        points: wayPoints
      );
      expect(result['wayPoints'].length, wayPoints.length);
      expect(result['wayPoints'][0]['lat'], wayPoints.first.lat);
      expect(result['wayPoints'][1]['lon'], wayPoints.last.lon);
      expect(result['endTime'], '2025-07-31 10:03');
    });

    test('Cuando la fecha no tiene horas y minutos', (){
      endTime = DateTime(2025, 07, 31);
      final result = routeExecutionsRemoteAdapter.getJsonFromRouteExecutionUpdate(
        endTime: endTime,
        points: wayPoints
      );
      expect(result['endTime'], '2025-07-31 00:00');
    });
  });
}