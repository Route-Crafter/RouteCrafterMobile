import 'package:flutter_test/flutter_test.dart';
import 'package:routes_mobile/data/adapters/routes_remote_adapter.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/domain/exceptions.dart';

late RoutesRemoteAdapterImpl routeRemoteAdapter;

void main(){
  setUp((){
    routeRemoteAdapter = RoutesRemoteAdapterImpl();
  });

  group('getRoutesFromData', (){
    dynamic data;
    test('Cuando la data está bien', (){
      data = [
        {'id': 'asdf1234', 'name': 'Route1', 'description': 'desc 1'},
        {'id': 'asdf1143', 'name': 'Route2', 'description': 'desc 2'}
      ];
      final routes = [
        TransportRoute(uuid: 'asdf1234', name: 'Route1', description: 'desc 1', executions: []),
        TransportRoute(uuid: 'asdf1143', name: 'Route2', description: 'desc 2', executions: [])
      ];
      final result = routeRemoteAdapter.getRoutesFromData(data);
      expect(result.length, routes.length);
      expect(result[0].uuid, routes[0].uuid);
      expect(result[1].name, routes[1].name);
    });

    test('Cuando la data está bien', (){
      data = {'id': 'asdf1234', 'name': 'Route1', 'description': 'desc 1'};
      try{
        routeRemoteAdapter.getRoutesFromData(data);
        fail('Debería haber lanzado una excepción');
      }catch(exception){
        expect(exception is GeneralException, true);
        expect((exception as GeneralException).meessage, 'Ha ocurrido un error con el formato de los datos.');
      }
    });
  });    

  test('getRouteFromData Cuando la data está bien', (){
    final data = {'id': 'asdf1234', 'name': 'Route1', 'description': 'desc 1'};
    final route = TransportRoute(uuid: 'asdf1234', name: 'Route1', description: 'desc 1', executions: []);
    final result = routeRemoteAdapter.getRouteFromData(data);
    expect(result.uuid, route.uuid);
    expect(result.name, route.name);
    expect(result.description, route.description);
  });  
}