import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:routes_mobile/data/services/route_executions_services.dart';
import 'package:routes_mobile/data/services/routes_services.dart';
import 'package:routes_mobile/domain/entities/places/place_info.dart';
import 'package:routes_mobile/domain/entities/places/zone.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/utils/geolocation.dart';

part 'routes_event.dart';
part 'routes_state.dart';

class RoutesBloc extends Bloc<RoutesEvent, RoutesState> {
  final Geolocation geolocation;
  final RoutesServices routesServices;
  final RouteExecutionsServices routeExecutionsServices;
  DateTime? _lastUpdateMapCall;
  RoutesBloc({
    required this.geolocation,
    required this.routesServices,
    required this.routeExecutionsServices
  }) : super(RoutesInitial()) {
    on<RoutesEvent>((event, emit) async {
      if( event is InitBloc ){
        await _initBloc( emit );
      } else if ( event is LoadMapInitialization ) {
        await _loadMapInitialization( event, emit );
      } else if ( event is UpdateMapPosition ){
        await _updateMapPosition( event, emit );
      } else if ( event is SelectRoute ) {
        await _selectRoute( event, emit );
      } else if ( event is SelectRouteExecution ){
        _selectRouteExecution( event, emit );
      }
    });
  }

  Future<void> _initBloc( Emitter<RoutesState> emit ) async {
    final placeInfo = await geolocation.getPlaceInfoFromLocation();
    final currentPosition = await geolocation.getCurrentPosition();
    List<TransportRoute>? routes;
    if(placeInfo != null){
      routes = await routesServices.getByPlaceInfo(info: placeInfo);
    }
    emit(OnRoutesMap(
      place: placeInfo!,
      devicePosition: Marker(
        markerId: const MarkerId('device_position'),
        position: LatLng(currentPosition!.lat, currentPosition.lon)
      ),
      routes: routes ?? [],
      loadingRoutes: false
    ));
  }

  Future<void> _loadMapInitialization( LoadMapInitialization event, Emitter<RoutesState> emit ) async {
    final initState = state as OnRoutesMap;
    emit(initState.copyWith(
      mapController: event.controller
    ));
  }

  Future<void> _updateMapPosition( UpdateMapPosition event, Emitter<RoutesState> emit ) async {
    final currentTime = DateTime.now();
    _lastUpdateMapCall = currentTime;
    await Future.delayed(const Duration(milliseconds: 1000));
    if( _lastUpdateMapCall!.isBefore(currentTime) || _lastUpdateMapCall!.isAtSameMomentAs(currentTime) ) {
      await _updateMapByNewPosition(event.position, emit);
    }
  }

  Future<void> _updateMapByNewPosition( LatLng position, Emitter<RoutesState> emit ) async {
    final initState = state as OnRoutesMap;
    emit(initState.copyWith(
      loadingRoutes: true
    ));
    try{
      final placeInfo = await geolocation.getPlaceInfoFromLocation(location: position);
      if(
        placeInfo != null &&
        placeInfo.countryIsoCode != null &&
        placeInfo.state != null &&
        placeInfo.city != null &&
        (
          placeInfo.countryIsoCode != initState.place.countryIsoCode ||
          placeInfo.state != initState.place.state ||
          placeInfo.city != initState.place.city
        )
      ){
        final routes = await routesServices.getByPlaceInfo(info: placeInfo);
        emit(initState.copyWith(
          routes: routes,
          loadingRoutes: false
        ));
      }else {
        emit(initState.copyWith(
          loadingRoutes: false
        ));
      }
    }on Object {
      emit(initState.copyWith(
        loadingRoutes: false
      ));
    }
  }

  Future<void> _selectRoute( SelectRoute event, Emitter<RoutesState> emit ) async {
    final selectedRoute = event.route;
    if(selectedRoute != null){
      final initState = state as OnRoutesMap;
      final executions = await routeExecutionsServices.getExecutionsByRouteId(selectedRoute.uuid);
      final routeDetail = await routesServices.getById(selectedRoute.uuid);
      final updatedRoute = routeDetail.copyWith(
        executions: executions
      );
      final routePolyline = Polyline(
        polylineId: const PolylineId('route'),
        points: updatedRoute.coords.map(
          (p) => LatLng(p.lat, p.lon)
        ).toList(),
        jointType: JointType.bevel,
        width: 5,
        color: event.mainColor
      );
      final executionsPolylines = updatedRoute.executions.map(
        (exc) => Polyline(
          polylineId: PolylineId('${exc.id}'),
          points: exc.points.map(
            (p) => LatLng(p.lat, p.lon)
          ).toList(),
          jointType: JointType.bevel,
          width: 5,
          color: Color.fromARGB(
            255,
            Random().nextInt(255),
            Random().nextInt(255),
            Random().nextInt(255)
          )
        )
      ).toList();
      emit(initState.copyWith(
        selectedRoute: updatedRoute,
        executionsPolylines: executionsPolylines,
        selectedExecution: NoValue(),
        routePolyline: routePolyline
      ));
      if(updatedRoute.executions.isNotEmpty){
        _updateCamera(updatedRoute.executions.first, initState.mapController);
      }
    }
    
  }

  void _updateCamera(RouteExecution execution, GoogleMapController? controller) => 
    controller?.animateCamera(CameraUpdate.newLatLng(
        LatLng(
          execution.points.first.lat,
          execution.points.first.lon
        )
      ));

  void _selectRouteExecution( SelectRouteExecution event, Emitter<RoutesState> emit ) {
    final routeExecution = event.routeExecution;
    if(routeExecution != null){
      final initState = state as OnRoutesMap;
      emit(initState.copyWith(
        selectedExecution: routeExecution
      ));
      _updateCamera(routeExecution, initState.mapController);
    }
  }
}
