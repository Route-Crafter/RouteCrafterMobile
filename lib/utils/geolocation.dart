import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routes_mobile/data/services/location_services.dart';
import 'package:routes_mobile/domain/entities/places/place_info.dart';
import 'package:routes_mobile/domain/entities/routes/way_point.dart';

abstract class Geolocation{
  Future<PlaceInfo?> getPlaceInfoFromLocation({LatLng? location});
  Future<WayPoint?> getCurrentPosition();
  Future<void> addOnChanged(Function(DirectionedWayPoint) onChanged);
  Future<void> stopOnChanged();
}

class GeoLocationImpl implements Geolocation{
  final LocationServices locationServices;
  GeoLocationImpl({required this.locationServices});

  @override
  Future<PlaceInfo?> getPlaceInfoFromLocation({LatLng? location})async{
    if(await _verifyPermissions()){
      // Obtener la posición del usuario

      Position? position;
      if(location == null){
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }

      // Obtener el país a partir de las coordenadas de la ubicación
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location?.latitude ?? position!.latitude,
        location?.longitude ?? position!.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placeMark = placemarks.first;
        return PlaceInfo(
          countryName: placeMark.country,
          countryIsoCode: placeMark.isoCountryCode,
          state: placeMark.administrativeArea,
          city: placeMark.locality
        );
      }else{
        return null;
      }
    }
    return null;    
  }

  Future<bool> _verifyPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    // Verificar permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Usuario bloqueó permisos permanentemente
      return false;
    }
    return true;
  }

  @override
  Future<WayPoint?> getCurrentPosition() async {
    if(await _verifyPermissions()){
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return WayPoint(
        lat: position.latitude,
        lon: position.longitude,
        speed: position.speed
      );
    }
    return null;
  }

  @override
  Future<void> addOnChanged(Function(DirectionedWayPoint) onChanged) async {
    await _verifyPermissions();
    await locationServices.startService(onChanged);
  }
  
  @override
  Future<void> stopOnChanged() async {
    await locationServices.endService();
  }
}