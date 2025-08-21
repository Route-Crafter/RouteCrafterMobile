
import 'package:routes_mobile/domain/entities/places/zone.dart';
import 'package:routes_mobile/domain/exceptions.dart';

abstract class StatesRemoteAdapter {
  List<Zone> getStatesFromData(dynamic data);
  Map<String, dynamic> getBodyFromState({required String name});
  Zone getStateFromData(dynamic data);
}

class StatesRemoteAdapterImpl implements StatesRemoteAdapter{

  @override
  List<Zone> getStatesFromData(data) {
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
  Map<String, dynamic> getBodyFromState({required String name}) => {
    'name': name
  };

  @override
  Zone getStateFromData(data) {
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