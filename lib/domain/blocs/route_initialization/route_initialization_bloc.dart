import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:routes_mobile/data/services/cities_services.dart';
import 'package:routes_mobile/data/services/countries_services.dart';
import 'package:routes_mobile/data/services/route_executions_services.dart';
import 'package:routes_mobile/data/services/routes_services.dart';
import 'package:routes_mobile/data/services/states_services.dart';
import 'package:routes_mobile/domain/entities/places/place_info.dart';
import 'package:routes_mobile/domain/entities/places/zone.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/utils/geolocation.dart';

part 'route_initialization_event.dart';
part 'routes_initialization_state.dart';

class RouteInitializationBloc extends Bloc<RouteInitializationEvent, RouteInitializationState>{
  final Geolocation geolocation;
  final CountriesServices countriesServices;
  final StatesServices statesServices;
  final CitiesServices citiesServices;
  final RoutesServices routesServices;
  final RouteExecutionsServices routeExecutionsServices;
  RouteInitializationBloc({
    required this.geolocation,
    required this.countriesServices,
    required this.statesServices,
    required this.citiesServices,
    required this.routesServices,
    required this.routeExecutionsServices
  }):super(RoutesInit()){
    on<RouteInitializationEvent>((event, emit)async{
      if(event is Init){
        await _init( emit );
      } else if (event is SelectCountry) {
        await _selectCountry( event, emit );
      } else if (event is SelectState) {
        await _selectState( event, emit );
      } else if (event is SelectCity) {
        await _selectCity( event, emit );
      } else if (event is SelectRoute) {
        await _selectRoute( event, emit );
      } else if (event is InitCountryCreation) {
        await _initCountryCreation( emit );
      } else if( event is EndCountryCreation ) {
        await _endCountryCreation( emit );
      } else if (event is InitStateCreation) {
        await _initStateCreation( emit );
      } else if( event is EndStateCreation ) {
        await _endStateCreation( emit );
      } else if (event is InitCityCreation) {
        await _initCityCreation( emit );
      } else if( event is EndCityCreation ) {
        await _endCityCreation( emit );
      } else if (event is InitRouteCreation) {
        await _initRouteCreation( emit );
      } else if( event is EndRouteCreation ) {
        await _endRouteCreation( emit );
      } else if (event is BackToRouteInitialization) {
        _backToRouteInitialization( emit );
      } else if (event is EndRouteInitialization) {
        await _endRouteInitialization( emit );
      }
    });
  }

  Future<void> _init(Emitter<RouteInitializationState> emit)async{
    final initState = OnRouteInitialization(
      loadingCountries: true,
      loadingStates: true,
      loadingCities: true,
      loadingRoutes: true,
      executionLicensePlate: TextEditingController()
    );
    emit(initState);
    final locationInfo = await geolocation.getPlaceInfoFromLocation();
    Country? country;
    List<Country> countries;
    Zone? state;
    List<Zone> states = [];
    Zone? city;
    List<Zone> cities = [];
    List<TransportRoute> routes = [];
    countries = await countriesServices.getCountries();
    if(locationInfo != null){
      //country
      final locationCountryIso = locationInfo.countryIsoCode;
      if(locationCountryIso != null){
        final countryIndex = countries.indexWhere(
          (c) => c.iso.toLowerCase() == locationCountryIso.toLowerCase()
        );
        if(countryIndex != -1){
          country = countries[countryIndex];
          states = await statesServices.getStatesByCountryId(country.id);
          //State
          final locationState = locationInfo.state;
          if(locationState != null){
            final stateIndex = states.indexWhere(
              (s) => s.name.toLowerCase() == locationState.toLowerCase()
            );
            if(stateIndex != -1){
              state = states[stateIndex];
              cities = await citiesServices.getCitiesByStateId(state.id);
              //City
              final locationCity = locationInfo.city;
              if(locationCity != null){
                final cityIndex = cities.indexWhere(
                  (c) => c.name.toLowerCase() == locationCity.toLowerCase()
                );
                if(cityIndex != -1){
                  city = cities[cityIndex];
                  routes = await routesServices.getRoutesByCityId(city.id);
                }else{
                  final createdCity = await citiesServices.createCity(
                    name: locationCity,
                    stateId: state.id
                  );
                  cities = [
                    ...cities,
                    createdCity
                  ];
                }
              }
            }else{
              final createdState = await statesServices.createState(
                name: locationState,
                countryId: country.id
              );
              states = [
                ...states,
                createdState
              ];
            }
          }
        }else if(locationInfo.countryName != null){
          final createdCountry = await countriesServices.createCountry(
            name: locationInfo.countryName!,
            iso: locationCountryIso
          );
          countries = [
            ...countries,
            createdCountry
          ];
          
        }
      }
    }
    emit(OnRouteInitialization(
      locationInfo: locationInfo,
      countries: countries,
      countryStates: states,
      stateCities: cities,
      cityRoutes: routes,
      selectedCountry: country,
      selectedState: state,
      selectedCity: city,
      executionLicensePlate: initState.executionLicensePlate
    ));
  }

  Future<void> _selectCountry(SelectCountry event, Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteInitialization;
    emit(initState.copyWith(
      loadingStates: true,
      loadingCities: true,
      loadingRoutes: true
    ));
    final selectedCountry = event.country;
    final countryStates = await statesServices.getStatesByCountryId(selectedCountry.id);
    emit(OnRouteInitialization(
      locationInfo: initState.locationInfo,
      countries: initState.countries,
      selectedCountry: selectedCountry,
      countryStates: countryStates,
      executionLicensePlate: initState.executionLicensePlate
    ));
  }

  Future<void> _selectState(SelectState event, Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteInitialization;
    emit(initState.copyWith(
      loadingCities: true,
      loadingRoutes: true
    ));
    final selectedState = event.state;
    final stateCities = await citiesServices.getCitiesByStateId(selectedState.id);
    emit(OnRouteInitialization(
      locationInfo: initState.locationInfo,
      countries: initState.countries,
      selectedCountry: initState.selectedCountry,
      countryStates: initState.countryStates,
      selectedState: selectedState,
      stateCities: stateCities,
      executionLicensePlate: initState.executionLicensePlate
    ));
  }

  Future<void> _selectCity(SelectCity event, Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteInitialization;
    emit(initState.copyWith(
      loadingRoutes: true
    ));
    final selectedCity = event.city;
    final cityRoutes = await routesServices.getRoutesByCityId(selectedCity.id);
    emit(OnRouteInitialization(
      locationInfo: initState.locationInfo,
      countries: initState.countries,
      selectedCountry: initState.selectedCountry,
      countryStates: initState.countryStates,
      selectedState: initState.selectedState,
      stateCities: initState.stateCities,
      selectedCity: selectedCity,
      cityRoutes: cityRoutes,
      executionLicensePlate: initState.executionLicensePlate
    ));
  }

  Future<void> _selectRoute(SelectRoute event, Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteInitialization;
    final selectedRoute = event.route;
    emit(initState.copyWith(
      selectedRoute: selectedRoute,
      canEnd: true
    ));
  }

  Future<void> _initCountryCreation(Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteInitialization;
    if(initState.locationInfo?.countryIsoCode != null){
      emit(OnCountryCreation.fromParent(
        parent: initState,
        name: TextEditingController(),
        iso: TextEditingController()
      ));
    }
  }

  Future<void> _endCountryCreation(Emitter<RouteInitializationState> emit) async {
    final initState = state as OnCountryCreation;
    final newCountry = await countriesServices.createCountry(
      name: initState.name.text,
      iso: initState.iso.text
    );
    emit(OnRouteInitialization(
      locationInfo: initState.locationInfo,
      countries: [
        ...initState.countries,
        newCountry
      ],
      selectedCountry: newCountry,
      executionLicensePlate: initState.executionLicensePlate
    ));
  }

  Future<void> _initStateCreation(Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteInitialization;
    if(initState.locationInfo?.state != null){
      emit(OnStateCreation.fromParent(
        parent: initState,
        name: TextEditingController()
      ));
    }
  }

  Future<void> _endStateCreation(Emitter<RouteInitializationState> emit) async {
    final initState = state as OnStateCreation;
    final newState = await statesServices.createState(
      name: initState.name.text,
      countryId: initState.selectedCountry!.id
    );
    emit(OnRouteInitialization(
      locationInfo: initState.locationInfo,
      countries: initState.countries,
      selectedCountry: initState.selectedCountry,
      countryStates: [
        ...initState.countryStates,
        newState
      ],
      selectedState: newState,
      executionLicensePlate: initState.executionLicensePlate
    ));
  }

  Future<void> _initCityCreation(Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteInitialization;
    if(initState.locationInfo?.state != null){
      emit(OnCityCreation.fromParent(
        parent: initState,
        name: TextEditingController()
      ));
    }
  }

  Future<void> _endCityCreation(Emitter<RouteInitializationState> emit) async {
    final initState = state as OnCityCreation;
    final newCity = await citiesServices.createCity(
      name: initState.name.text,
      stateId: initState.selectedState!.id
    );
    emit(OnRouteInitialization(
      locationInfo: initState.locationInfo,
      countries: initState.countries,
      selectedCountry: initState.selectedCountry,
      countryStates: initState.countryStates,
      selectedState: initState.selectedState,
      stateCities: [
        ...initState.stateCities,
        newCity
      ],
      selectedCity: newCity,
      executionLicensePlate: initState.executionLicensePlate
    ));
  }

  Future<void> _initRouteCreation(Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteInitialization;
    emit(OnRouteCreation.fromParent(
      parent: initState,
      name: TextEditingController(),
      description: TextEditingController()
    ));
  }

  Future<void> _endRouteCreation(Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteCreation;
    final newRoute = await routesServices.createRoute(
      name: initState.name.text,
      description: initState.description.text,
      cityId: initState.selectedCity!.id
    );
    emit(OnRouteInitialization(
      locationInfo: initState.locationInfo,
      countries: initState.countries,
      selectedCountry: initState.selectedCountry,
      countryStates: initState.countryStates,
      selectedState: initState.selectedState,
      stateCities: initState.stateCities,
      selectedCity: initState.selectedCity,
      cityRoutes: [
        ...initState.cityRoutes,
        newRoute
      ],
      selectedRoute: newRoute,
      executionLicensePlate: initState.executionLicensePlate,
      canEnd: true
    ));
  }

  void _backToRouteInitialization(Emitter<RouteInitializationState> emit) {
    final initState = state as OnCreation;
    emit(OnRouteInitialization.fromChild(initState));
  }

  Future<void> _endRouteInitialization(Emitter<RouteInitializationState> emit) async {
    final initState = state as OnRouteInitialization;
    final selectedRoute = initState.selectedRoute;
    final licensePlate = initState.executionLicensePlate.text;
    if(initState.canEnd){
      emit(initState.copyWith(
        loadingCountries: true,
        loadingStates: true,
        loadingCities: true,
        loadingRoutes: true
      ));
      final newExecution = await routeExecutionsServices.createExecution(
        licensePlate: licensePlate,
        initTime: DateTime.now(),
        routeId: selectedRoute!.uuid
      );
      emit(OnRouteInitialized(
        route: selectedRoute,
        routeExecution: newExecution
      ));
    }
  }
}