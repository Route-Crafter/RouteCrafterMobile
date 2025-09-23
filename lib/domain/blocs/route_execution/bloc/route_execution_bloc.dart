import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:routes_mobile/data/services/route_executions_services.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';
import 'package:routes_mobile/utils/geolocation.dart';
part 'route_execution_event.dart';
part 'route_execution_state.dart';

class RouteExecutionBloc extends Bloc<RouteExecutionEvent, RouteExecutionState> {
  static const _minRoutePointsToEnd = 10;

  final RouteExecutionsServices routeExecutionsServices;
  final Geolocation geolocation;
  RouteExecutionBloc({
    required this.routeExecutionsServices,
    required this.geolocation
  }) : super(RouteExecutionInitial()) {
    on<RouteExecutionEvent>((event, emit)async{
      if( event is InitBloc ){
        await _initBloc( event, emit );
      } else if( event is InitRouteExecutionProccess){
        await _initRouteExecutionProccess( event, emit );
      } else if (event is _UpdateMap){
        await _updateMap( event, emit );
      } else  if( event is EndRouteExecutionProccess){
        await _endRouteExecutionProccess( emit );
      }

    });
  }

  Future<void> _initBloc( InitBloc event, Emitter<RouteExecutionState> emit ) async {
    final initLocation = await geolocation.getCurrentPosition();
    if(initLocation != null){
      final markerImage = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/drawable/route_vehicle_right.png'
      );
      emit(OnRouteExecution(
        route: event.route,
        routeExecution: event.routeExecution,
        positionMarker: Marker(
          markerId: const MarkerId('Position'),
          position: LatLng(initLocation.lat, initLocation.lon),
          icon: markerImage
        ),
        wayPoints: [initLocation],
        status: RouteExecutionStatus.loading
      ));
    }else{
      //TODO: Implementar manejo de errores
    }
  }

  Future<void> _initRouteExecutionProccess( InitRouteExecutionProccess event, Emitter<RouteExecutionState> emit ) async {
    final initState = state as OnRouteExecution;
    final mapController = event.mapController;
    emit(initState.copyWith(
      mapController: mapController,
      routePolyline: Polyline(
        polylineId: const PolylineId('Route'),
        points: [
          initState.positionMarker.position
        ]
      )
    ));
    geolocation.addOnChanged((position){
      add(_UpdateMap(newPoint: position));
    });
  }

  Future<void> _updateMap( _UpdateMap event, Emitter<RouteExecutionState> emit ) async {
    final initState = state as OnRouteExecution;
    final position = event.newPoint;
    final newLatLng = LatLng(position.lat, position.lon);
    initState.mapController!.animateCamera(CameraUpdate.newLatLng(newLatLng));
    final newWayPoints = [
      ...initState.wayPoints,
      position
    ];
    final bearing = position.bearing;
    BitmapDescriptor? routeImg;
    MarkerSide markerSide;
    if(bearing <= 180 && initState.markerSide == MarkerSide.left){
      routeImg = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/drawable/route_vehicle_right.png'
      );
      markerSide = MarkerSide.right;
    }else if(bearing > 180 && initState.markerSide == MarkerSide.right){
      routeImg = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/drawable/route_vehicle_left.png'
      );
      markerSide = MarkerSide.left;
    } else {
      markerSide = initState.markerSide;
    }
    emit(initState.copyWith(
      positionMarker: Marker(
        markerId: initState.positionMarker.markerId,
        position: newLatLng,
        rotation: markerSide == MarkerSide.right?
          (bearing - 90) % 360:
          (bearing - 270) % 360,
        icon: routeImg ?? initState.positionMarker.icon
      ),
      markerSide: markerSide,
      routePolyline: Polyline(
        polylineId: const PolylineId('Route'),
        points: [
          ...initState.routePolyline!.points,
          newLatLng
        ]
      ),
      wayPoints: newWayPoints
    ));
  }

  Future<void> _endRouteExecutionProccess( Emitter<RouteExecutionState> emit ) async {
    final initState = state as OnRouteExecution;
    var wayPoints = initState.wayPoints;
    var routePolyline = initState.routePolyline!;
    emit(initState.copyWith(
      status: RouteExecutionStatus.loading
    ));
    if(wayPoints.length >= _minRoutePointsToEnd){
      await geolocation.stopOnChanged();
      final endTime = DateTime.now();
      final endedExecution = await routeExecutionsServices.updateExecution(
        routeId: initState.route.uuid,
        endTime: endTime,
        wayPoints: initState.wayPoints,
        routeExecutionId: initState.routeExecution.id
      );
      if(endedExecution.points.length != wayPoints.length){
        wayPoints = endedExecution.points;
        routePolyline = Polyline(
          polylineId: routePolyline.mapsId,
          points: wayPoints.map(
            (wP) => LatLng(wP.lat, wP.lon)
          ).toList()
        );
      }
      final initRouteImage = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)), // tamaño base
        'assets/drawable/route_init.png',
      );
      final endRouteImage = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)), // tamaño base
        'assets/drawable/route_end.png',
      );
      emit(initState.copyWith(
        routeExecution: endedExecution,
        status: RouteExecutionStatus.ended,
        routeInitImage: initRouteImage,
        routeEndImage: endRouteImage
      ));
    }else {
      //TODO: Implementar manejo de errores
    }
    
  }
}
