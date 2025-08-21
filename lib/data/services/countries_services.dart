import 'package:dio/dio.dart';
import 'package:routes_mobile/data/adapters/countries_remote_adapter.dart';
import 'package:routes_mobile/data/services/remote_data_source.dart';
import 'package:routes_mobile/data/services/services_routes.dart';
import 'package:routes_mobile/domain/entities/places/zone.dart';

abstract class CountriesServices{
  Future<List<Country>> getCountries();
  Future<Country> createCountry({required String name, required String iso});
}

class CountriesServicesImpl extends RemoteDataSource implements CountriesServices{

  final CountriesRemoteAdapter adapter;
  CountriesServicesImpl({
    required super.dio,
    required this.adapter
  });

  @override
  Future<List<Country>> getCountries()async{
    final response = await super.executeDioService(
      () async => await dio.get(ServicesRoutes.countries)
    );
    return adapter.getCountriesFromData(response.data);
  }

  @override
  Future<Country> createCountry({required String name, required String iso})async{
    final response = await super.executeDioService(
      () async {
        final body = adapter.getJsonFromCountry(name: name, iso: iso);
        final headers = super.getJsonContentHeaders();
        return await dio.post(
          ServicesRoutes.countries,
          data: body,
          options: Options(
            headers: headers
          )
        );
      }
    );
    return adapter.getCountryFromData(response.data);
  }
}