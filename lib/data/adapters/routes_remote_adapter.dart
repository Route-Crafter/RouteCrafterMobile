import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';
import 'package:routes_mobile/domain/exceptions.dart';

abstract class RoutesRemoteAdapter {
  List<TransportRoute> getRoutesFromData(dynamic data);
  Map<String, dynamic> getJsonFromRoute({
    required String name,
    required String description
  });
  TransportRoute getRouteFromData(dynamic data);
}

class RoutesRemoteAdapterImpl implements RoutesRemoteAdapter{

  @override
  List<TransportRoute> getRoutesFromData(data) {
    try{
      final list = (data as List).cast<Map<String, dynamic>>();
      return list.map(
        (r) => TransportRoute(
          uuid: r['id'],
          name: r['name'],
          description: r['description'],
          executions: []
        
        )
      ).toList();
    } on Object {
      throw const GeneralException(meessage: 'Ha ocurrido un error con el formato de los datos.');
    }
  }

  @override
  Map<String, dynamic> getJsonFromRoute({required String name, required String description}) => {
    'name': name,
    'description': description
  };

  @override
  TransportRoute getRouteFromData(data) {
    try{
      final jsonData = (data as Map).cast<String, dynamic>();
      return TransportRoute(
        uuid: jsonData['id'],
        name: jsonData['name'],
        description: jsonData['description'],
        executions: [],
        coords: ( ( jsonData['coords'] ?? [] ) as List ).map(
          (c) => WayPoint(
            lat: c['lat'],
            lon: c['lon'],
            speed: 0
          )
        ).toList()
      );
    } on Object catch(exception, stackTrace){
      print(stackTrace);
      throw const GeneralException(meessage: 'Ha ocurrido un error con el formato de los datos.');
    }
  }

  

}