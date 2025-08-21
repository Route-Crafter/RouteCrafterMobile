part of 'route_initialization_bloc.dart';

abstract class RouteInitializationEvent {

}

class Init extends RouteInitializationEvent {

}

class SelectCountry extends RouteInitializationEvent {
  final Country country;
  SelectCountry(this.country);
}

class SelectState extends RouteInitializationEvent {
  final Zone state;
  SelectState(this.state);
}

class SelectCity extends RouteInitializationEvent {
  final Zone city;
  SelectCity(this.city);
}

class SelectRoute extends RouteInitializationEvent {
  final TransportRoute route;
  SelectRoute(this.route);
}

class InitCountryCreation extends RouteInitializationEvent {

}

class EndCountryCreation extends RouteInitializationEvent {
  
}

class InitStateCreation extends RouteInitializationEvent {

}

class EndStateCreation extends RouteInitializationEvent {
  
}

class InitCityCreation extends RouteInitializationEvent {

}

class EndCityCreation extends RouteInitializationEvent {
  
}

class InitRouteCreation extends RouteInitializationEvent {

}

class EndRouteCreation extends RouteInitializationEvent {
  
}

class BackToRouteInitialization extends RouteInitializationEvent {
  
}

class EndRouteInitialization extends RouteInitializationEvent {
  
}