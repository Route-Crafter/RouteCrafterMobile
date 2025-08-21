import 'package:routes_mobile/domain/entities/places/zone.dart';
import 'package:routes_mobile/domain/exceptions.dart';

abstract class CountriesRemoteAdapter{
  List<Country> getCountriesFromData(dynamic data);
  Map<String, dynamic> getJsonFromCountry({
    required String name,
    required String iso
  });
  Country getCountryFromData(dynamic data);
}

class CountriesRemoteAdapterImpl implements CountriesRemoteAdapter{
  @override
  List<Country> getCountriesFromData(data) {
    try{
      final list = (data as List).cast<Map<String, dynamic>>();
      return list.map<Country>(
        (c) => Country(
          id: c['id'],
          name: c['name'],
          iso: c['iso']
        )
      ).toList();
    }on Object{
      throw const GeneralException(meessage: 'Ha ocurrido un error con el formato de los datos');
    }
  }

  @override
  Map<String, dynamic> getJsonFromCountry({required String name, required String iso}) => {
    'name': name,
    'iso': iso
  };
  
  @override
  Country getCountryFromData(data) {
    try{
      final jsonData = (data as Map).cast<String, dynamic>();
      return Country(
        id: jsonData['id'],
        name: jsonData['name'],
        iso: jsonData['iso']
      );
    }on Object{
      throw const GeneralException(meessage: 'Ha ocurrido un error con el formato de los datos');
    }
  }
}
