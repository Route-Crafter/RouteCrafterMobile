import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:routes_mobile/data/services/cities_services.dart';
import 'package:routes_mobile/data/services/countries_services.dart';
import 'package:routes_mobile/data/services/route_executions_services.dart';
import 'package:routes_mobile/data/services/routes_services.dart';
import 'package:routes_mobile/data/services/states_services.dart';
import 'package:routes_mobile/domain/blocs/route_initialization/route_initialization_bloc.dart';
import 'package:routes_mobile/domain/entities/places/place_info.dart';
import 'package:routes_mobile/domain/entities/places/zone.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/utils/geolocation.dart';

import 'route_initialization_bloc_test.mocks.dart';

late RouteInitializationBloc routesBloc;
late MockCountriesServices countriesServices;
late MockStatesServices statesServices;
late MockCitiesServices citiesServices;
late MockRoutesServices routesServices;
late MockGeolocation geolocation;
late MockRouteExecutionsServices routeExecutionsServices;

@GenerateNiceMocks([
  MockSpec<CountriesServices>(),
  MockSpec<StatesServices>(),
  MockSpec<CitiesServices>(),
  MockSpec<RoutesServices>(),
  MockSpec<RouteExecutionsServices>(),
  MockSpec<Geolocation>()
])
void main(){
  setUp((){
    countriesServices = MockCountriesServices();
    statesServices = MockStatesServices();
    citiesServices = MockCitiesServices();
    routesServices = MockRoutesServices();
    routeExecutionsServices = MockRouteExecutionsServices();
    geolocation = MockGeolocation();
    routesBloc = RouteInitializationBloc(
      geolocation: geolocation,
      countriesServices: countriesServices,
      statesServices: statesServices,
      citiesServices: citiesServices,
      routesServices: routesServices,
      routeExecutionsServices: routeExecutionsServices
    );
  });

  group('init', (){
    late List<Country> initCountries;
    late List<Zone> initStates;
    late List<Zone> initCities;
    late List<TransportRoute> initRoutes;
    setUpAll((){
      provideDummy<Country>(const Country(id: 1, name: '', iso: ''));
      provideDummy<Zone>(const Zone(id: 1, name: ''));
      provideDummy<TransportRoute>(TransportRoute(uuid: '', name: '', description: '', executions: []));
    });
    setUp((){
      initCountries = const [
        Country(id: 1, name: 'Colombia', iso: 'COL'),
        Country(id: 2, name: 'Argentina', iso: 'ARG')
      ];
    });

    blocTest<RouteInitializationBloc, RouteInitializationState>(
      'Cuando la información de la geolocalización es nula',
      build: (){
        when(countriesServices.getCountries())
          .thenAnswer((_) async => initCountries);
        when(geolocation.getPlaceInfoFromLocation())
          .thenAnswer((_) async => null);
          return routesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        isA<OnRouteInitialization>(),
        predicate(
          (state) => state is OnRouteInitialization &&
            state.countries.length == initCountries.length &&
            state.countries.first.iso == initCountries.first.iso &&
            state.countryStates.isEmpty &&
            !state.loadingCountries &&
            !state.loadingStates &&
            !state.loadingCities &&
            !state.loadingRoutes
        )
      ],
      verify: (bloc){
        verify(countriesServices.getCountries()).called(1);
        verifyNever(statesServices.getStatesByCountryId(any));
      }
    );

    blocTest<RouteInitializationBloc, RouteInitializationState>(
      'Cuando el country de la localización es nulo',
      build: (){
        when(countriesServices.getCountries())
        .thenAnswer((_) async => initCountries);
        when(geolocation.getPlaceInfoFromLocation())
          .thenAnswer((_) async => PlaceInfo());
          return routesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        isA<OnRouteInitialization>(),
        predicate(
          (state) => state is OnRouteInitialization &&
            state.countries.length == initCountries.length &&
            state.countries.first.iso == initCountries.first.iso &&
            state.countryStates.isEmpty &&
            !state.loadingCountries &&
            !state.loadingStates &&
            !state.loadingCities &&
            !state.loadingRoutes
        )
      ]
    );

    blocTest<RouteInitializationBloc, RouteInitializationState>(
      'Cuando el country de la localización no es nulo y está en la lista de países',
      build: (){
        initStates = const [
          Zone(id: 1, name: 'Cundinamarca'),
          Zone(id: 2, name: 'Tolima')
        ];
        when(countriesServices.getCountries())
        .thenAnswer((_) async => initCountries);
        when(geolocation.getPlaceInfoFromLocation())
          .thenAnswer((_) async => PlaceInfo(
            countryName: initCountries.first.name,
            countryIsoCode: initCountries.first.iso
          ));
        when(statesServices.getStatesByCountryId(any))
          .thenAnswer((_) async => initStates);
          return routesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        isA<OnRouteInitialization>(),
        predicate(
          (state) => state is OnRouteInitialization &&
            state.countries.length == initCountries.length &&
            state.countries.first.iso == initCountries.first.iso &&
            state.countryStates.length == initStates.length &&
            state.countryStates.first.name == initStates.first.name &&
            state.stateCities.isEmpty &&
            !state.loadingCountries &&
            !state.loadingStates &&
            !state.loadingCities &&
            !state.loadingRoutes
        )
      ],
      verify: (bloc){
        verify(countriesServices.getCountries()).called(1);
        verify(statesServices.getStatesByCountryId(initCountries.first.id)).called(1);
        verifyNever(citiesServices.getCitiesByStateId(any));
      },
    );

    blocTest<RouteInitializationBloc, RouteInitializationState>(
      'Cuando el country de la localización no es nulo y no está en la lista de países',
      build: (){
        when(countriesServices.getCountries())
        .thenAnswer((_) async => initCountries);
        when(geolocation.getPlaceInfoFromLocation())
          .thenAnswer((_) async => PlaceInfo(
            countryName: 'Ecuador',
            countryIsoCode: 'ECU'
          ));
        when(countriesServices.createCountry(name: anyNamed('name'), iso: anyNamed('iso')))
          .thenAnswer( (_) async => const Country(
            id: 3,
            name: 'Ecuador',
            iso: 'ECU'
          ));
        return routesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        isA<OnRouteInitialization>(),
        predicate(
          (state) => state is OnRouteInitialization &&
            state.countries.length == initCountries.length + 1&&
            state.countries.first.iso == initCountries.first.iso &&
            state.countries.last.iso == 'ECU' &&
            state.countryStates.isEmpty &&
            !state.loadingCountries &&
            !state.loadingStates &&
            !state.loadingCities &&
            !state.loadingRoutes
        )
      ],
      verify: (bloc){
        verify(countriesServices.getCountries()).called(1);
        verify(countriesServices.createCountry(name: 'Ecuador', iso: 'ECU'));
        verifyNever(statesServices.getStatesByCountryId(any));
      },
    );

    blocTest<RouteInitializationBloc, RouteInitializationState>(
      'Cuando el state de la localización no es nulo y sí está en la lista de states',
      build: (){
        initStates = const [
          Zone(id: 1, name: 'Cundinamarca'),
          Zone(id: 2, name: 'Tolima')
        ];
        initCities = const [
          Zone(id: 1, name: 'Girardot'),
          Zone(id: 2, name: 'Fusagasugá')
        ];
        when(countriesServices.getCountries())
        .thenAnswer((_) async => initCountries);
        when(geolocation.getPlaceInfoFromLocation())
          .thenAnswer((_) async => PlaceInfo(
            countryName: 'Colombia',
            countryIsoCode: 'COL',
            state: 'Cundinamarca'
          ));
        when(statesServices.getStatesByCountryId(any))
          .thenAnswer((_) async => initStates);
        when(citiesServices.getCitiesByStateId(any))
          .thenAnswer((_) async => initCities);
        return routesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        isA<OnRouteInitialization>(),
        predicate(
          (state) => state is OnRouteInitialization &&
            state.countries.length == initCountries.length &&
            state.countries.first.iso == initCountries.first.iso &&
            state.countryStates.length == initStates.length &&
            state.countryStates.first.name == initStates.first.name &&
            state.stateCities.length == initCities.length &&
            state.stateCities.first.name == initCities.first.name &&
            state.cityRoutes.isEmpty &&
            !state.loadingCountries &&
            !state.loadingStates &&
            !state.loadingCities &&
            !state.loadingRoutes
        )
      ],
      verify: (bloc){
        verify(countriesServices.getCountries()).called(1);
        verify(statesServices.getStatesByCountryId(initCountries.first.id)).called(1);
        verify(citiesServices.getCitiesByStateId(initStates.first.id));
        verifyNever(routesServices.getRoutesByCityId(any));
      },
    );

    blocTest<RouteInitializationBloc, RouteInitializationState>(
      'Cuando el state de la localización no es nulo y no está en la lista de states',
      build: (){
        initStates = const [
          Zone(id: 1, name: 'Cundinamarca'),
          Zone(id: 2, name: 'Tolima')
        ];
        when(countriesServices.getCountries())
        .thenAnswer((_) async => initCountries);
        when(geolocation.getPlaceInfoFromLocation())
          .thenAnswer((_) async => PlaceInfo(
            countryName: 'Colombia',
            countryIsoCode: 'COL',
            state: 'Amazonas'
          ));
        when(statesServices.getStatesByCountryId(any))
          .thenAnswer((_) async => initStates);
        when(statesServices.createState(name: anyNamed('name'), countryId: anyNamed('countryId')))
          .thenAnswer((_) async => const Zone(id: 101, name: 'Amazonas'));
        return routesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        isA<OnRouteInitialization>(),
        predicate(
          (state) => state is OnRouteInitialization &&
            state.countries.length == initCountries.length &&
            state.countries.first.iso == initCountries.first.iso &&
            state.countryStates.length == initStates.length + 1 &&
            state.countryStates.last.name == 'Amazonas' &&
            state.stateCities.isEmpty &&
            !state.loadingCountries &&
            !state.loadingStates &&
            !state.loadingCities &&
            !state.loadingRoutes
        )
      ],
      verify: (bloc){
        verify(countriesServices.getCountries()).called(1);
        verify(statesServices.getStatesByCountryId(initCountries.first.id)).called(1);
        verify(statesServices.createState(name: 'Amazonas', countryId: initCountries.first.id));
        verifyNever(citiesServices.getCitiesByStateId(any));
      }
    );

    blocTest<RouteInitializationBloc, RouteInitializationState>(
      'Cuando el city de la localización no es nulo y sí está en la lista de states',
      build: (){
        initStates = const [
          Zone(id: 1, name: 'Cundinamarca'),
          Zone(id: 2, name: 'Tolima')
        ];
        initCities = const [
          Zone(id: 1, name: 'Girardot'),
          Zone(id: 2, name: 'Fusagasugá')
        ];
        initRoutes = [
          TransportRoute(uuid: 'route1', name: 'Route 1', description: 'Route 1 Description', executions: []),
          TransportRoute(uuid: 'route2', name: 'Route 2', description: 'Route 2 Description', executions: [])
        ];
        when(countriesServices.getCountries())
        .thenAnswer((_) async => initCountries);
        when(geolocation.getPlaceInfoFromLocation())
          .thenAnswer((_) async => PlaceInfo(
            countryName: 'Colombia',
            countryIsoCode: 'COL',
            state: 'Cundinamarca',
            city: 'Girardot'
          ));
        when(statesServices.getStatesByCountryId(any))
          .thenAnswer((_) async => initStates);
        when(citiesServices.getCitiesByStateId(any))
          .thenAnswer((_) async => initCities);
        when(routesServices.getRoutesByCityId(any))
          .thenAnswer((_) async => initRoutes);
        return routesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        isA<OnRouteInitialization>(),
        predicate(
          (state) => state is OnRouteInitialization &&
            state.countries.length == initCountries.length &&
            state.countries.first.iso == initCountries.first.iso &&
            state.countryStates.length == initStates.length &&
            state.countryStates.first.name == initStates.first.name &&
            state.stateCities.length == initCities.length &&
            state.stateCities.first.name == initCities.first.name &&
            state.cityRoutes.length == initRoutes.length &&
            state.cityRoutes.first.uuid == initRoutes.first.uuid &&
            !state.loadingCountries &&
            !state.loadingStates &&
            !state.loadingCities &&
            !state.loadingRoutes
        )
      ],
      verify: (bloc){
        verify(countriesServices.getCountries()).called(1);
        verify(statesServices.getStatesByCountryId(initCountries.first.id)).called(1);
        verify(citiesServices.getCitiesByStateId(initStates.first.id)).called(1);
        verify(routesServices.getRoutesByCityId(initCities.first.id)).called(1);
      }
    );

    blocTest<RouteInitializationBloc, RouteInitializationState>(
      'Cuando el city de la localización no es nulo y no está en la lista de states',
      build: (){
        initStates = const [
          Zone(id: 1, name: 'Cundinamarca'),
          Zone(id: 2, name: 'Tolima')
        ];
        initCities = const [
          Zone(id: 1, name: 'Girardot'),
          Zone(id: 2, name: 'Fusagasugá')
        ];
        when(countriesServices.getCountries())
        .thenAnswer((_) async => initCountries);
        when(geolocation.getPlaceInfoFromLocation())
          .thenAnswer((_) async => PlaceInfo(
            countryName: 'Colombia',
            countryIsoCode: 'COL',
            state: 'Cundinamarca',
            city: 'Agua de Dios'
          ));
        when(statesServices.getStatesByCountryId(any))
          .thenAnswer((_) async => initStates);
        when(citiesServices.getCitiesByStateId(any))
          .thenAnswer((_) async => initCities);
        when(citiesServices.createCity(name: anyNamed('name'), stateId: anyNamed('stateId')))
          .thenAnswer((_) async => const Zone(id: 3, name: 'Agua de Dios'));
        return routesBloc;
      },
      act: (bloc) => bloc.add(Init()),
      expect: () => [
        isA<OnRouteInitialization>(),
        predicate(
          (state) => state is OnRouteInitialization &&
            state.countries.length == initCountries.length &&
            state.countries.first.iso == initCountries.first.iso &&
            state.countryStates.length == initStates.length &&
            state.countryStates.first.name == initStates.first.name &&
            state.stateCities.length == initCities.length + 1 &&
            state.stateCities.last.name == 'Agua de Dios' &&
            state.cityRoutes.isEmpty &&
            !state.loadingCountries &&
            !state.loadingStates &&
            !state.loadingCities &&
            !state.loadingRoutes
        )
      ],
      verify: (bloc){
        verify(countriesServices.getCountries()).called(1);
        verify(statesServices.getStatesByCountryId(initCountries.first.id)).called(1);
        verify(citiesServices.getCitiesByStateId(initStates.first.id)).called(1);
        verify(citiesServices.createCity(name: 'Agua de Dios', stateId: initStates.first.id));
        verifyNever(routesServices.getRoutesByCityId(any));
      }
    );
  });
}