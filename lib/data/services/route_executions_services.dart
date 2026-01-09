import 'package:dio/dio.dart';
import 'package:routes_mobile/data/adapters/route_executions_remote_adapter.dart';
import 'package:routes_mobile/data/services/remote_data_source.dart';
import 'package:routes_mobile/data/services/services_routes.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';

abstract class RouteExecutionsServices {
  Future<List<RouteExecution>> getExecutionsByRouteId(String id);
  Future<RouteExecution> createExecution({
    required String licensePlate,
    required DateTime initTime,
    required String routeId
  });
  Future<RouteExecution> updateExecution({
    required DateTime endTime,
    required List<WayPoint> wayPoints,
    required int routeExecutionId
  });
}

class RouteExecutionsServicesImpl extends RemoteDataSource implements RouteExecutionsServices{
  
  final RouteExecutionsRemoteAdapter adapter;
  RouteExecutionsServicesImpl({
    required super.dio,
    required this.adapter
  });

  @override
  Future<List<RouteExecution>> getExecutionsByRouteId(String id) async {
    final result = await super.executeDioService(
      () async => await dio.get(
        '${ServicesRoutes.routes}/$id/executions',
        options: Options(
          headers: super.getJsonContentHeaders()
        )
      )
    );
    return adapter.getExecutionsFromData(result.data);
  }

  @override
  Future<RouteExecution> createExecution({
    required String licensePlate, 
    required DateTime initTime, 
    required String routeId
  }) async {
    final result = await super.executeDioService(() async {
      final headers = super.getJsonContentHeaders();
      final body = adapter.getJsonFromRouteExecutionCreation(
        licensePlate: licensePlate,
        initTime: initTime
      );
      return await dio.post(
        '${ServicesRoutes.routes}/$routeId/executions',
        options: Options(
          headers: headers
        ),
        data: body
      );
    });
    return adapter.getExecutionFromInitData(result.data);
  }

  @override
  Future<RouteExecution> updateExecution({
    required DateTime endTime, 
    required List<WayPoint> wayPoints,
    required int routeExecutionId
  }) async {
    final result = await super.executeDioService(() async {
      final headers = super.getJsonContentHeaders();
      final body = adapter.getJsonFromRouteExecutionUpdate(
        endTime: endTime,
        points: wayPoints
      );
      return await dio.patch(
        '${ServicesRoutes.executions}/$routeExecutionId',
        options: Options(
          headers: headers
        ),
        data: body
      );
    });
    return adapter.getExecutionFromEndData(result.data);
  }

}