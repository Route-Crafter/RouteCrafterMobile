part of 'route_initialization_bloc.dart';

abstract class RouteInitializationState {

}

class RoutesInit extends RouteInitializationState {
  
}

class OnRouteInitialization extends RouteInitializationState{
  final PlaceInfo? locationInfo;
  final List<Country> countries;
  final List<Zone> countryStates;
  final List<Zone> stateCities;
  final List<TransportRoute> cityRoutes;

  final Country? selectedCountry;
  final Zone? selectedState;
  final Zone? selectedCity;
  final TransportRoute? selectedRoute;
  final TextEditingController executionLicensePlate;

  final bool loadingCountries;
  final bool loadingStates;
  final bool loadingCities;
  final bool loadingRoutes;
  
  final bool canEnd;
  final String? errorMessage;
  OnRouteInitialization({
    this.locationInfo,
    this.countries = const [],
    this.countryStates = const [],
    this.stateCities = const [],
    this.cityRoutes = const [],
    this.selectedCountry,
    this.selectedState,
    this.selectedCity,
    this.selectedRoute,
    required this.executionLicensePlate,
    this.loadingCountries = false,
    this.loadingStates = false,
    this.loadingCities = false,
    this.loadingRoutes = false,
    this.canEnd = false,
    this.errorMessage
  });

  OnRouteInitialization copyWith({
    List<Country>? countries,
    List<Zone>? countryStates,
    List<Zone>? stateCities,
    List<TransportRoute>? cityRoutes,
    Country? selectedCountry,
    Zone? selectedState,
    Zone? selectedCity,
    TransportRoute? selectedRoute,
    bool? loadingCountries,
    bool? loadingStates,
    bool? loadingCities,
    bool? loadingRoutes,
    bool? canEnd,
    String? errorMessage
  }) => OnRouteInitialization(
    locationInfo: locationInfo,
    countries: countries ?? this.countries,
    countryStates: countryStates ?? this.countryStates,
    stateCities: stateCities ?? this.stateCities,
    cityRoutes: cityRoutes ?? this.cityRoutes,
    selectedCountry: selectedCountry ?? this.selectedCountry,
    selectedState: selectedState ?? this.selectedState,
    selectedCity: selectedCity ?? this.selectedCity,
    selectedRoute: selectedRoute ?? this.selectedRoute,
    executionLicensePlate: executionLicensePlate,
    loadingCountries: loadingCountries ?? this.loadingCountries,
    loadingStates: loadingStates ?? this.loadingStates,
    loadingCities: loadingCities ?? this.loadingCities,
    loadingRoutes: loadingRoutes ?? this.loadingRoutes,
    canEnd: canEnd ?? this.canEnd,
    errorMessage: errorMessage ?? this.errorMessage
  );

  static OnRouteInitialization fromChild(
    OnRouteInitialization child
  ) => OnRouteInitialization(
    locationInfo: child.locationInfo,
    countries: child.countries,
    countryStates: child.countryStates,
    stateCities: child.stateCities,
    cityRoutes: child.cityRoutes,
    selectedCountry: child.selectedCountry,
    selectedState: child.selectedState,
    selectedCity: child.selectedCity,
    selectedRoute: child.selectedRoute,
    executionLicensePlate: child.executionLicensePlate,
    loadingCountries: child.loadingCountries,
    loadingStates: child.loadingStates,
    loadingCities: child.loadingCities,
    loadingRoutes: child.loadingRoutes,
    canEnd: child.canEnd,
    errorMessage: child.errorMessage
  );
}

class OnCreation extends OnRouteInitialization{
  
  OnCreation({
    super.locationInfo,
    super.countries,
    super.countryStates,
    super.stateCities,
    super.cityRoutes,
    super.selectedCountry,
    super.selectedState,
    super.selectedCity,
    super.selectedRoute,
    required super.executionLicensePlate,
    super.loadingCountries,
    super.loadingStates,
    super.loadingCities,
    super.loadingRoutes,
    super.errorMessage,
    super.canEnd
  });

  @override
  OnCreation copyWith({
    List<Country>? countries,
    List<Zone>? countryStates,
    List<Zone>? stateCities,
    List<TransportRoute>? cityRoutes,
    Country? selectedCountry,
    Zone? selectedState,
    Zone? selectedCity,
    TransportRoute? selectedRoute,
    bool? loadingCountries,
    bool? loadingStates,
    bool? loadingCities,
    bool? loadingRoutes,
    String? errorMessage,
    bool? canEnd
  }) => OnCreation(
    locationInfo: locationInfo,
    countries: countries ?? this.countries,
    countryStates: countryStates ?? this.countryStates,
    stateCities: stateCities ?? this.stateCities,
    cityRoutes: cityRoutes ?? this.cityRoutes,
    selectedCountry: selectedCountry ?? this.selectedCountry,
    selectedState: selectedState ?? this.selectedState,
    selectedCity: selectedCity ?? this.selectedCity,
    selectedRoute: selectedRoute ?? this.selectedRoute,
    executionLicensePlate: super.executionLicensePlate,
    loadingCountries: loadingCountries ?? this.loadingCountries,
    loadingStates: loadingStates ?? this.loadingStates,
    loadingCities: loadingCities ?? this.loadingCities,
    loadingRoutes: loadingRoutes ?? this.loadingRoutes,
    errorMessage: errorMessage ?? this.errorMessage,
    canEnd: canEnd ?? this.canEnd
  );
}

class OnCountryCreation extends OnCreation{
  final TextEditingController name;
  final TextEditingController iso;
  OnCountryCreation({
    super.locationInfo,
    super.countries,
    super.countryStates,
    super.stateCities,
    super.cityRoutes,
    super.selectedCountry,
    super.selectedState,
    super.selectedCity,
    super.selectedRoute,
    required super.executionLicensePlate,
    super.loadingCountries,
    super.loadingStates,
    super.loadingCities,
    super.loadingRoutes,
    super.errorMessage,
    required this.name,
    required this.iso,
    super.canEnd
  });

  @override
  OnCountryCreation copyWith({
    List<Country>? countries,
    List<Zone>? countryStates,
    List<Zone>? stateCities,
    List<TransportRoute>? cityRoutes,
    Country? selectedCountry,
    Zone? selectedState,
    Zone? selectedCity,
    TransportRoute? selectedRoute,
    bool? loadingCountries,
    bool? loadingStates,
    bool? loadingCities,
    bool? loadingRoutes,
    String? errorMessage,
    bool? canEnd
  }) => OnCountryCreation(
    locationInfo: locationInfo,
    countries: countries ?? this.countries,
    countryStates: countryStates ?? this.countryStates,
    stateCities: stateCities ?? this.stateCities,
    cityRoutes: cityRoutes ?? this.cityRoutes,
    selectedCountry: selectedCountry ?? this.selectedCountry,
    selectedState: selectedState ?? this.selectedState,
    selectedCity: selectedCity ?? this.selectedCity,
    selectedRoute: selectedRoute ?? this.selectedRoute,
    executionLicensePlate: executionLicensePlate,
    loadingCountries: loadingCountries ?? this.loadingCountries,
    loadingStates: loadingStates ?? this.loadingStates,
    loadingCities: loadingCities ?? this.loadingCities,
    loadingRoutes: loadingRoutes ?? this.loadingRoutes,
    errorMessage: errorMessage ?? this.errorMessage,
    canEnd: canEnd ?? this.canEnd,
    name: name,
    iso: iso
  );

  static OnCountryCreation fromParent({
    required OnRouteInitialization parent,
    required TextEditingController name,
    required TextEditingController iso
  }) => OnCountryCreation(
    locationInfo: parent.locationInfo,
    countries: parent.countries,
    countryStates: parent.countryStates,
    stateCities: parent.stateCities,
    cityRoutes: parent.cityRoutes,
    selectedCountry: parent.selectedCountry,
    selectedState: parent.selectedState,
    selectedCity: parent.selectedCity,
    selectedRoute: parent.selectedRoute,
    executionLicensePlate: parent.executionLicensePlate,
    loadingCountries: parent.loadingCountries,
    loadingStates: parent.loadingStates,
    loadingCities: parent.loadingCities,
    loadingRoutes: parent.loadingRoutes,
    errorMessage: parent.errorMessage,
    canEnd: false,
    name: name,
    iso: iso
  );
}

class OnStateCreation extends OnCreation{
  final TextEditingController name;
  OnStateCreation({
    super.locationInfo,
    super.countries,
    super.countryStates,
    super.stateCities,
    super.cityRoutes,
    super.selectedCountry,
    super.selectedState,
    super.selectedCity,
    super.selectedRoute,
    required super.executionLicensePlate,
    super.loadingCountries,
    super.loadingStates,
    super.loadingCities,
    super.loadingRoutes,
    super.errorMessage,
    required this.name,
    required super.canEnd
  });

  @override
  OnStateCreation copyWith({
    List<Country>? countries,
    List<Zone>? countryStates,
    List<Zone>? stateCities,
    List<TransportRoute>? cityRoutes,
    Country? selectedCountry,
    Zone? selectedState,
    Zone? selectedCity,
    TransportRoute? selectedRoute,
    bool? loadingCountries,
    bool? loadingStates,
    bool? loadingCities,
    bool? loadingRoutes,
    String? errorMessage,
    bool? canEnd
  }) => OnStateCreation(
    locationInfo: locationInfo,
    countries: countries ?? this.countries,
    countryStates: countryStates ?? this.countryStates,
    stateCities: stateCities ?? this.stateCities,
    cityRoutes: cityRoutes ?? this.cityRoutes,
    selectedCountry: selectedCountry ?? this.selectedCountry,
    selectedState: selectedState ?? this.selectedState,
    selectedCity: selectedCity ?? this.selectedCity,
    selectedRoute: selectedRoute ?? this.selectedRoute,
    executionLicensePlate: executionLicensePlate,
    loadingCountries: loadingCountries ?? this.loadingCountries,
    loadingStates: loadingStates ?? this.loadingStates,
    loadingCities: loadingCities ?? this.loadingCities,
    loadingRoutes: loadingRoutes ?? this.loadingRoutes,
    errorMessage: errorMessage ?? this.errorMessage,
    canEnd: canEnd ?? this.canEnd,
    name: name
  );

  static OnStateCreation fromParent({
    required OnRouteInitialization parent,
    required TextEditingController name
  }) => OnStateCreation(
    locationInfo: parent.locationInfo,
    countries: parent.countries,
    countryStates: parent.countryStates,
    stateCities: parent.stateCities,
    cityRoutes: parent.cityRoutes,
    selectedCountry: parent.selectedCountry,
    selectedState: parent.selectedState,
    selectedCity: parent.selectedCity,
    selectedRoute: parent.selectedRoute,
    executionLicensePlate: parent.executionLicensePlate,
    loadingCountries: parent.loadingCountries,
    loadingStates: parent.loadingStates,
    loadingCities: parent.loadingCities,
    loadingRoutes: parent.loadingRoutes,
    errorMessage: parent.errorMessage,
    canEnd: false,
    name: name
  );
}

class OnCityCreation extends OnCreation{
  final TextEditingController name;
  OnCityCreation({
    super.locationInfo,
    super.countries,
    super.countryStates,
    super.stateCities,
    super.cityRoutes,
    super.selectedCountry,
    super.selectedState,
    super.selectedCity,
    super.selectedRoute,
    required super.executionLicensePlate,
    super.loadingCountries,
    super.loadingStates,
    super.loadingCities,
    super.loadingRoutes,
    super.errorMessage,
    required this.name,
    required super.canEnd
  });

  @override
  OnCityCreation copyWith({
    List<Country>? countries,
    List<Zone>? countryStates,
    List<Zone>? stateCities,
    List<TransportRoute>? cityRoutes,
    Country? selectedCountry,
    Zone? selectedState,
    Zone? selectedCity,
    TransportRoute? selectedRoute,
    bool? loadingCountries,
    bool? loadingStates,
    bool? loadingCities,
    bool? loadingRoutes,
    String? errorMessage,
    bool? canEnd
  }) => OnCityCreation(
    locationInfo: locationInfo,
    countries: countries ?? this.countries,
    countryStates: countryStates ?? this.countryStates,
    stateCities: stateCities ?? this.stateCities,
    cityRoutes: cityRoutes ?? this.cityRoutes,
    selectedCountry: selectedCountry ?? this.selectedCountry,
    selectedState: selectedState ?? this.selectedState,
    selectedCity: selectedCity ?? this.selectedCity,
    selectedRoute: selectedRoute ?? this.selectedRoute,
    executionLicensePlate: executionLicensePlate,
    loadingCountries: loadingCountries ?? this.loadingCountries,
    loadingStates: loadingStates ?? this.loadingStates,
    loadingCities: loadingCities ?? this.loadingCities,
    loadingRoutes: loadingRoutes ?? this.loadingRoutes,
    errorMessage: errorMessage ?? this.errorMessage,
    canEnd: canEnd ?? this.canEnd,
    name: name
  );

  static OnCityCreation fromParent({
    required OnRouteInitialization parent,
    required TextEditingController name
  }) => OnCityCreation(
    locationInfo: parent.locationInfo,
    countries: parent.countries,
    countryStates: parent.countryStates,
    stateCities: parent.stateCities,
    cityRoutes: parent.cityRoutes,
    selectedCountry: parent.selectedCountry,
    selectedState: parent.selectedState,
    selectedCity: parent.selectedCity,
    selectedRoute: parent.selectedRoute,
    executionLicensePlate: parent.executionLicensePlate,
    loadingCountries: parent.loadingCountries,
    loadingStates: parent.loadingStates,
    loadingCities: parent.loadingCities,
    loadingRoutes: parent.loadingRoutes,
    errorMessage: parent.errorMessage,
    canEnd: false,
    name: name
  );
}

class OnRouteCreation extends OnCreation{
  final TextEditingController name;
  final TextEditingController description;
  OnRouteCreation({
    super.locationInfo,
    super.countries,
    super.countryStates,
    super.stateCities,
    super.cityRoutes,
    super.selectedCountry,
    super.selectedState,
    super.selectedCity,
    super.selectedRoute,
    required super.executionLicensePlate,
    super.loadingCountries,
    super.loadingStates,
    super.loadingCities,
    super.loadingRoutes,
    super.errorMessage,
    super.canEnd,
    required this.name,
    required this.description
  });

  @override
  OnRouteCreation copyWith({
    List<Country>? countries,
    List<Zone>? countryStates,
    List<Zone>? stateCities,
    List<TransportRoute>? cityRoutes,
    Country? selectedCountry,
    Zone? selectedState,
    Zone? selectedCity,
    TransportRoute? selectedRoute,
    bool? loadingCountries,
    bool? loadingStates,
    bool? loadingCities,
    bool? loadingRoutes,
    String? errorMessage,
    bool? canEnd
  }) => OnRouteCreation(
    locationInfo: locationInfo,
    countries: countries ?? this.countries,
    countryStates: countryStates ?? this.countryStates,
    stateCities: stateCities ?? this.stateCities,
    cityRoutes: cityRoutes ?? this.cityRoutes,
    selectedCountry: selectedCountry ?? this.selectedCountry,
    selectedState: selectedState ?? this.selectedState,
    selectedCity: selectedCity ?? this.selectedCity,
    selectedRoute: selectedRoute ?? this.selectedRoute,
    executionLicensePlate: executionLicensePlate,
    loadingCountries: loadingCountries ?? this.loadingCountries,
    loadingStates: loadingStates ?? this.loadingStates,
    loadingCities: loadingCities ?? this.loadingCities,
    loadingRoutes: loadingRoutes ?? this.loadingRoutes,
    errorMessage: errorMessage ?? this.errorMessage,
    canEnd: canEnd ?? this.canEnd,
    name: name,
    description: description
  );

  static OnRouteCreation fromParent({
    required OnRouteInitialization parent,
    required TextEditingController name,
    required TextEditingController description
  }) => OnRouteCreation(
    locationInfo: parent.locationInfo,
    countries: parent.countries,
    countryStates: parent.countryStates,
    stateCities: parent.stateCities,
    cityRoutes: parent.cityRoutes,
    selectedCountry: parent.selectedCountry,
    selectedState: parent.selectedState,
    selectedCity: parent.selectedCity,
    selectedRoute: parent.selectedRoute,
    executionLicensePlate: parent.executionLicensePlate,
    loadingCountries: parent.loadingCountries,
    loadingStates: parent.loadingStates,
    loadingCities: parent.loadingCities,
    loadingRoutes: parent.loadingRoutes,
    errorMessage: parent.errorMessage,
    canEnd: false,
    name: name,
    description: description
  );
}

class OnRouteInitialized extends RouteInitializationState{
  final TransportRoute route;
  final RouteExecution routeExecution;
  OnRouteInitialized({
    required this.route,
    required this.routeExecution
  });
}