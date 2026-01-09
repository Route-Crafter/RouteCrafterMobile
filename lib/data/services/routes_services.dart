import 'package:dio/dio.dart';
import 'package:routes_mobile/data/adapters/routes_remote_adapter.dart';
import 'package:routes_mobile/data/services/remote_data_source.dart';
import 'package:routes_mobile/data/services/services_routes.dart';
import 'package:routes_mobile/domain/entities/places/place_info.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';

abstract class RoutesServices{
  Future<List<TransportRoute>> getRoutesByCityId(int id);
  Future<TransportRoute> createRoute({
    required String name,
    required String description,
    required int cityId
  });
  Future<List<TransportRoute>> getByPlaceInfo({
    required PlaceInfo info
  });
  Future<TransportRoute> getById(String id);
}

class RoutesServicesImpl extends RemoteDataSource implements RoutesServices{
  final RoutesRemoteAdapter adapter;
  RoutesServicesImpl({
    required super.dio,
    required this.adapter
  });

  @override
  Future<List<TransportRoute>> getRoutesByCityId(int id) async {
    final result = await super.executeDioService(
      () async => await dio.get(
        '${ServicesRoutes.cities}/$id/routes'
      )
    );
    return adapter.getRoutesFromData(result.data);
  }

  @override
  Future<TransportRoute> createRoute({required String name, required String description, required int cityId}) async {
    final result = await super.executeDioService(
      () async {
        final headers = super.getJsonContentHeaders();
        final body = adapter.getJsonFromRoute(name: name, description: description);
        return await dio.post(
          '${ServicesRoutes.cities}/$cityId/routes',
          options: Options(
            headers: headers
          ),
          data: body
        );
      }
    );
    return adapter.getRouteFromData(result.data);
  }
  
  @override
  Future<List<TransportRoute>> getByPlaceInfo({required PlaceInfo info}) async {
    final result = await super.executeDioService(
      () async => await dio.get(
        ServicesRoutes.routes,
        options: Options(
          headers: super.getJsonContentHeaders()
        ),
        queryParameters: {
          'countryIso': info.countryIsoCode,
          'stateName': info.state,
          'cityName': info.city
        }
      )
    );
    return adapter.getRoutesFromData(result.data);
  }
  
  @override
  Future<TransportRoute> getById(String id) async {
    final result = await super.executeDioService(
      () async => await dio.get(
        '${ServicesRoutes.routes}/$id',
        options: Options(
          headers: super.getJsonContentHeaders()
        )
      )
    );
    return adapter.getRouteFromData(result.data);
  }

}