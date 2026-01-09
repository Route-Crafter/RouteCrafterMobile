import 'package:flutter_test/flutter_test.dart';
import 'package:routes_mobile/domain/blocs/route_execution/bloc/route_execution_bloc.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';
import 'route_execution_bloc_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Después de InitRouteExecutionProccess, el evento de geolocation actualiza wayPoints y routePolyline', () async {
    // Arrange
    final initialPosition = DirectionedWayPoint(lat: 1.0, lon: 1.0, speed: 0.0, bearing: 90.0);
    final fakeGeo = FakeGeolocation(current: initialPosition);
    final fakeService = FakeRouteExecutionsServices();
    final bloc = RouteExecutionBloc(routeExecutionsServices: fakeService, geolocation: fakeGeo);

    final route = TransportRoute(uuid: 'r1', name: 'R', description: 'D', executions: []);
    final routeExecution = RouteExecution(id: 1, licensePlate: 'LP', initTime: DateTime.now(), endTime: null, points: [initialPosition]);

    // Act: Se inicializa el bloc
    bloc.add(StartBloc(route: route, routeExecution: routeExecution));
    await waitForCondition(() => bloc.state is OnRouteExecution);
    expect(bloc.state, isA<OnRouteExecution>());

    // Provee un SimpleGoogleMapController falso e inicia la RouteExecution
    final mockController = SimpleGoogleMapController();
    bloc.add(InitRouteExecutionProccess(mapController: mockController));
    await waitForCondition(() => (bloc.state as OnRouteExecution).mapController != null);

    // Lanza un update de geolocation
    final newPoint = DirectionedWayPoint(lat: 2.0, lon: 2.0, speed: 0.0, bearing: 100.0);
    fakeGeo.trigger(newPoint);
    await waitForCondition(() => (bloc.state as OnRouteExecution).wayPoints.length >= 2);

    final currentState = bloc.state as OnRouteExecution;

    // Assert: wayPoints contiene el nuevo punto
    expect(currentState.wayPoints.length, greaterThanOrEqualTo(2));
    final lastWp = currentState.wayPoints.last as DirectionedWayPoint?;
    expect(lastWp, isNotNull);
    expect(lastWp!.lat, equals(newPoint.lat));
    expect(lastWp.lon, equals(newPoint.lon));

    // Assert: routePolyline points contiene el nuevo LatLng
    expect(currentState.routePolyline, isNotNull);
    final polyPoints = currentState.routePolyline!.points;
    expect(polyPoints, isNotEmpty);
    expect(polyPoints.last.latitude, equals(newPoint.lat));
    expect(polyPoints.last.longitude, equals(newPoint.lon));

    // Cleanup
    await bloc.close();
  });

  test('EndRouteExecutionProccess termina la ejecución y llama a updateExecution', () async {
    final initialPosition = DirectionedWayPoint(lat: 0.0, lon: 0.0, speed: 0.0, bearing: 0.0);
    final fakeGeo = FakeGeolocation(current: initialPosition);

    final trackingService = TrackingRouteExecutionsService();
    final bloc = RouteExecutionBloc(routeExecutionsServices: trackingService, geolocation: fakeGeo);

    final route = TransportRoute(uuid: 'r1', name: 'R', description: 'D', executions: []);
    final routeExecution = RouteExecution(id: 5, licensePlate: 'LP', initTime: DateTime.now(), endTime: null, points: [initialPosition]);

    // Act: Inicia el bloc y proceso
    bloc.add(StartBloc(route: route, routeExecution: routeExecution));
    await waitForCondition(() => bloc.state is OnRouteExecution);

    final mapController = SimpleGoogleMapController();
    bloc.add(InitRouteExecutionProccess(mapController: mapController));
    await waitForCondition(() => (bloc.state as OnRouteExecution).mapController != null);

    // Lanza suficientes updates (>= 10)
    for (var i = 0; i < 11; i++) {
      fakeGeo.trigger(DirectionedWayPoint(lat: i.toDouble(), lon: i.toDouble(), speed: 0.0, bearing: 0.0));
      await Future.delayed(const Duration(milliseconds: 5));
    }
    await waitForCondition(() => (bloc.state as OnRouteExecution).wayPoints.length >= 10);

    bloc.add(EndRouteExecutionProccess());
    await waitForCondition(() => (bloc.state as OnRouteExecution).status == RouteExecutionStatus.ended, timeout: const Duration(seconds: 2));

    final finalState = bloc.state as OnRouteExecution;
    expect(finalState.status, equals(RouteExecutionStatus.ended));
    expect(trackingService.updated, isTrue);

    await bloc.close();
  });
}
