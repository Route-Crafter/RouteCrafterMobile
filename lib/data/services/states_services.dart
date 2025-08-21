import 'package:dio/dio.dart';
import 'package:routes_mobile/data/adapters/states_remote_adapter.dart';
import 'package:routes_mobile/data/services/remote_data_source.dart';
import 'package:routes_mobile/data/services/services_routes.dart';
import 'package:routes_mobile/domain/entities/places/zone.dart';

abstract class StatesServices {
  Future<List<Zone>> getStatesByCountryId(int id);
  Future<Zone> createState({required String name, required int countryId});
}

class StatesServicesImpl extends RemoteDataSource implements StatesServices {
  final StatesRemoteAdapter adapter;
  StatesServicesImpl({
    required super.dio,
    required this.adapter
  });

  @override
  Future<List<Zone>> getStatesByCountryId(int id) async {
    final response = await super.executeDioService(
      () async => dio.get('${ServicesRoutes.countries}/$id/states')
    );
    return adapter.getStatesFromData(response.data);
  }

  @override
  Future<Zone> createState({required String name, required int countryId}) async {
    final response = await super.executeDioService(()async{
      final body = adapter.getBodyFromState(name: name);
      return await dio.post(
        '${ServicesRoutes.countries}/$countryId/states',
        data: body,
        options: Options(
          headers: super.getJsonContentHeaders()
        )
      );
    });
    return adapter.getStateFromData(response.data);
  }

  

}