import 'package:dio/dio.dart';
import 'package:routes_mobile/data/adapters/cities_remote_adapter.dart';
import 'package:routes_mobile/data/services/remote_data_source.dart';
import 'package:routes_mobile/data/services/services_routes.dart';
import 'package:routes_mobile/domain/entities/places/zone.dart';

abstract class CitiesServices {
  Future<List<Zone>> getCitiesByStateId(int id);
  Future<Zone> createCity({required String name, required int stateId});
}

class CitiesServicesImpl extends RemoteDataSource implements CitiesServices {
  final CitiesRemoteAdapter adapter;
  CitiesServicesImpl({
    required super.dio,
    required this.adapter
  });

  @override
  Future<List<Zone>> getCitiesByStateId(int id) async {
    final response = await super.executeDioService(
      () async => dio.get('${ServicesRoutes.states}/$id/cities')
    );
    return adapter.getCitiesFromData(response.data);
  }

  @override
  Future<Zone> createCity({required String name, required int stateId}) async {
    final response = await super.executeDioService(()async{
      final body = adapter.getBodyFromCity(name: name);
      return await dio.post(
        '${ServicesRoutes.states}/$stateId/cities',
        data: body,
        options: Options(
          headers: super.getJsonContentHeaders()
        )
      );
    });
    return adapter.getCityFromData(response.data);
  }
}