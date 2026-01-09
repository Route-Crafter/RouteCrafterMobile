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

    // Act: initialize bloc
    bloc.add(StartBloc(route: route, routeExecution: routeExecution));

    // Wait until initial OnRouteExecution state is emitted
    await waitForCondition(() => bloc.state is OnRouteExecution);
    expect(bloc.state, isA<OnRouteExecution>());

    // Provide a simple fake map controller and start the execution process
    final mockController = SimpleGoogleMapController();
    bloc.add(InitRouteExecutionProccess(mapController: mockController));

    // Wait until the bloc has registered the mapController and geolocation callback
    await waitForCondition(() => (bloc.state as OnRouteExecution).mapController != null);

    // Trigger a geolocation update
    final newPoint = DirectionedWayPoint(lat: 2.0, lon: 2.0, speed: 0.0, bearing: 100.0);
    fakeGeo.trigger(newPoint);

    // Wait until the bloc has processed the _UpdateMap and appended the new point
    await waitForCondition(() => (bloc.state as OnRouteExecution).wayPoints.length >= 2);

    final currentState = bloc.state as OnRouteExecution;

    // Assert: wayPoints contains the new point
    expect(currentState.wayPoints.length, greaterThanOrEqualTo(2));
    final lastWp = currentState.wayPoints.last as DirectionedWayPoint?;
    expect(lastWp, isNotNull);
    expect(lastWp!.lat, equals(newPoint.lat));
    expect(lastWp.lon, equals(newPoint.lon));

    // Assert: routePolyline points contain the new LatLng
    expect(currentState.routePolyline, isNotNull);
    final polyPoints = currentState.routePolyline!.points;
    expect(polyPoints, isNotEmpty);
    expect(polyPoints.last.latitude, equals(newPoint.lat));
    expect(polyPoints.last.longitude, equals(newPoint.lon));

    // Cleanup
    await bloc.close();
  });
}
