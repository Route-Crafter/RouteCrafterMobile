import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:routes_mobile/data/adapters/cities_remote_adapter.dart';
import 'package:routes_mobile/data/adapters/countries_remote_adapter.dart';
import 'package:routes_mobile/data/adapters/data_formatter.dart';
import 'package:routes_mobile/data/adapters/route_executions_remote_adapter.dart';
import 'package:routes_mobile/data/adapters/routes_remote_adapter.dart';
import 'package:routes_mobile/data/adapters/states_remote_adapter.dart';
import 'package:routes_mobile/data/services/cities_services.dart';
import 'package:routes_mobile/data/services/countries_services.dart';
import 'package:routes_mobile/data/services/location_services.dart';
import 'package:routes_mobile/data/services/route_executions_services.dart';
import 'package:routes_mobile/data/services/routes_services.dart';
import 'package:routes_mobile/data/services/states_services.dart';
import 'package:routes_mobile/domain/blocs/route_execution/bloc/route_execution_bloc.dart';
import 'package:routes_mobile/domain/blocs/route_initialization/route_initialization_bloc.dart';
import 'package:routes_mobile/domain/blocs/routes/routes_bloc.dart';
import 'package:routes_mobile/utils/geolocation.dart';

final sl = GetIt.instance;

void init(){
  sl.registerLazySingleton<LocationServices>(
    () => LocationServicesImpl()
  );
  sl.registerLazySingleton<Geolocation>(
    () => GeoLocationImpl(
      locationServices: sl<LocationServices>()
    )
  );
  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(
      baseUrl: 'http://10.0.2.2:1234'
    ))
  );
  sl.registerLazySingleton<DataFormatter>(
    () => DataFormatterImpl()
  );

  /*
  * ****************************** Routes **********************************
  */
  sl.registerLazySingleton<CountriesRemoteAdapter>(
    () => CountriesRemoteAdapterImpl()
  );
  sl.registerLazySingleton<CountriesServices>(
    () => CountriesServicesImpl(
      dio: sl<Dio>(),
      adapter: sl<CountriesRemoteAdapter>()
    )
  );
  sl.registerLazySingleton<StatesRemoteAdapter>(
    () => StatesRemoteAdapterImpl()
  );
  sl.registerLazySingleton<StatesServices>(
    () => StatesServicesImpl(
      dio: sl<Dio>(),
      adapter: sl<StatesRemoteAdapter>()
    )
  );
  sl.registerLazySingleton<CitiesRemoteAdapter>(
    () => CitiesRemoteAdapterImpl()
  );
  sl.registerLazySingleton<CitiesServices>(
    () => CitiesServicesImpl(
      dio: sl<Dio>(),
      adapter: sl<CitiesRemoteAdapter>()
    )
  );
  sl.registerLazySingleton<RoutesRemoteAdapter>(
    () => RoutesRemoteAdapterImpl()
  );
  sl.registerLazySingleton<RoutesServices>(
    () => RoutesServicesImpl(
      dio: sl<Dio>(),
      adapter: sl<RoutesRemoteAdapter>()
    )
  );
  sl.registerLazySingleton<RouteExecutionsRemoteAdapter>(
    () => RouteExecutionsRemoteAdapterImpl(
      dataFormatter: sl<DataFormatter>()
    )
  );
  sl.registerLazySingleton<RouteExecutionsServices>(
    () => RouteExecutionsServicesImpl(
      dio: sl<Dio>(),
      adapter: sl<RouteExecutionsRemoteAdapter>()
    )
  );
  sl.registerFactory<RouteInitializationBloc>(
    () => RouteInitializationBloc(
      geolocation: sl<Geolocation>(),
      countriesServices: sl<CountriesServices>(),
      statesServices: sl<StatesServices>(),
      citiesServices: sl<CitiesServices>(),
      routesServices: sl<RoutesServices>(),
      routeExecutionsServices: sl<RouteExecutionsServices>()
    )
  );

  sl.registerFactory<RouteExecutionBloc>(
    () => RouteExecutionBloc(
      routeExecutionsServices: sl<RouteExecutionsServices>(),
      geolocation: sl<Geolocation>()
    )
  );

  sl.registerFactory<RoutesBloc>(
    () => RoutesBloc(
      geolocation: sl<Geolocation>(),
      routesServices: sl<RoutesServices>(),
      routeExecutionsServices: sl<RouteExecutionsServices>()
    )
  );
}