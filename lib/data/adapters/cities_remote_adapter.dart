
import 'package:routes_mobile/domain/entities/places/zone.dart';
import 'package:routes_mobile/domain/exceptions.dart';

abstract class CitiesRemoteAdapter {
  List<Zone> getCitiesFromData(dynamic data);
  Map<String, dynamic> getBodyFromCity({required String name});
  Zone getCityFromData(data);
}

class CitiesRemoteAdapterImpl implements CitiesRemoteAdapter{

  @override
  List<Zone> getCitiesFromData(data) {
    try{
      final list = (data as List).cast<Map<String, dynamic>>();
      return list.map<Zone>(
        (c) => Zone(
          id: c['id'],
          name: c['name']
        )
      ).toList();
    } on Object{
      throw const GeneralException(meessage: 'Ha ocurrido un error con el formato de los datos');
    }
  }

  @override
  Map<String, dynamic> getBodyFromCity({required String name}) => {
    'name': name
  };

  @override
  Zone getCityFromData(data) {
    try{
      final jsonData = (data as Map).cast<String, dynamic>();
      return Zone(
        id: jsonData['id'],
        name: jsonData['name']
      );
    }on Object{
      throw const GeneralException(meessage: 'Ha ocurrido un error con el formato de los datos');
    }
  }
}