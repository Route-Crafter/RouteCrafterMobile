import 'package:flutter_test/flutter_test.dart';
import 'package:routes_mobile/data/adapters/countries_remote_adapter.dart';
import 'package:routes_mobile/domain/entities/places/zone.dart';
import 'package:routes_mobile/domain/exceptions.dart';

late CountriesRemoteAdapterImpl countriesRemoteAdapter;

void main(){
  setUp((){
    countriesRemoteAdapter = CountriesRemoteAdapterImpl();
  });

  group('getCountriesFromData', (){
    late dynamic data;
    test('cuando la data está bien formateada', (){
      data = [
        {'id': 1, 'name': 'Colombia', 'iso': 'COL'},
        {'id': 2, 'name': 'Argentina', 'iso': 'ARG'}
      ];
      const countries = [
        Country(id: 1, name: 'Colombia', iso: 'COL'),
        Country(id: 2, name: 'Argentina', iso: 'ARG')
      ];
      final result = countriesRemoteAdapter.getCountriesFromData(data);
      expect(countries.length, result.length);
      expect(countries[0].iso, result[0].iso);
      expect(countries[1].name, result[1].name);
    });

    test('cuando la data no está bien formateada', (){
      data = [
        {'id': 1, 'names': 'Colombia', 'iso': 'COL'},
        {'id': 2, 'name': 'Argentina', 'iso': 'ARG'}
      ];
      try{
        countriesRemoteAdapter.getCountriesFromData(data);
        fail('Debería lanzar un error');
      }catch(exception){
        expect(exception is GeneralException, true);
        expect((exception as GeneralException).meessage, 'Ha ocurrido un error con el formato de los datos');
      }
    });
  });

  group('getCountryFromData', (){
    late dynamic data;
    test('cuando la data está bien formateada', (){
      data = {'id': 1, 'name': 'Colombia', 'iso': 'COL'};
      const country = Country(id: 1, name: 'Colombia', iso: 'COL');
      final result = countriesRemoteAdapter.getCountryFromData(data);
      expect(country.id, result.id);
      expect(country.name, result.name);
      expect(country.iso, result.iso);
    });

    test('cuando la data no está bien formateada', (){
      data = [{'id': 1, 'name': 'Colombia', 'iso': 'COL'}];      
      try{
        countriesRemoteAdapter.getCountryFromData(data);
        fail('Debería lanzar un error');
      }catch(exception){
        expect(exception is GeneralException, true);
        expect((exception as GeneralException).meessage, 'Ha ocurrido un error con el formato de los datos');
      }
    });
  });
}