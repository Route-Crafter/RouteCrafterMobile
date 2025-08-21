// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routes_mobile/domain/blocs/route_initialization/route_initialization_bloc.dart';
import 'package:routes_mobile/domain/entities/places/zone.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/globals/injection_container.dart';
import 'package:routes_mobile/screens/app_dimens.dart';
import 'package:routes_mobile/screens/route_execution/route_execution_screen.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/city_creation_panel.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/country_creation_panel.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/creation_input.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/route_creation_panel.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/select.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/state_creation_panel.dart';

class RouteInitializationScreen extends StatelessWidget {
  const RouteInitializationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => sl<RouteInitializationBloc>(),
        child: BlocBuilder<RouteInitializationBloc, RouteInitializationState>(
          builder: (blocContext, blocState) {
            _executePostFrameCallbacks(blocState, blocContext);
            final inputWidth = AppDimens.widthPercentage(0.7, context);
            return blocState is OnRouteInitialization? 
              SafeArea(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(blocState is OnCreation){
                          BlocProvider.of<RouteInitializationBloc>(blocContext).add(BackToRouteInitialization());
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: AppDimens.widthPercentage(1, context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(flex: 20),
                            Select<Country>(
                              onTap: (country){
                                BlocProvider.of<RouteInitializationBloc>(blocContext).add(SelectCountry(country));   
                              },
                              defaultValue: 'Elegir país',
                              items: blocState.countries,
                              selected: blocState.selectedCountry,
                              getTextBySelected: (country) =>
                                '${country.name} - ${country.iso}',
                              isActive: !blocState.loadingCountries,
                              disabledMessage: 'Cargando',
                              width: inputWidth,
                              areTheSame: (c1, c2) => c1.id == c2?.id,
                              addNew: (){
                                BlocProvider.of<RouteInitializationBloc>(blocContext).add(InitCountryCreation());
                              }
                            ),
                            if(blocState.selectedCountry != null)
                              ...[
                                const Spacer(flex: 1),
                                Select<Zone>(
                                  onTap: (state){
                                    BlocProvider.of<RouteInitializationBloc>(blocContext).add(SelectState(state));     
                                  },
                                  defaultValue: 'Elegir Estado',
                                  items: blocState.countryStates,
                                  selected: blocState.selectedState,
                                  getTextBySelected: (state) =>
                                    state.name,
                                  isActive: !blocState.loadingStates,
                                  disabledMessage: 'Cargando',
                                  width: inputWidth,
                                  areTheSame: (s1, s2) => s1.id == s2?.id,
                                  addNew: (){
                                    BlocProvider.of<RouteInitializationBloc>(blocContext).add(InitStateCreation());
                                  }
                                )
                              ],
                            if(blocState.selectedState != null)
                              ...[
                                const Spacer(flex: 1),
                                Select<Zone>(
                                  onTap: (city){
                                    BlocProvider.of<RouteInitializationBloc>(blocContext).add(SelectCity(city));
                                  },
                                  defaultValue: 'Elegir Ciudad',
                                  items: blocState.stateCities,
                                  selected: blocState.selectedCity,
                                  getTextBySelected: (city) =>
                                    city.name,
                                  isActive: !blocState.loadingCities,
                                  disabledMessage: 'Cargando',
                                  width: inputWidth,
                                  areTheSame: (c1, c2) => c1.id == c2?.id,
                                  addNew: (){
                                    BlocProvider.of<RouteInitializationBloc>(blocContext).add(InitCityCreation());
                                  }
                                )
                              ],
                            if(blocState.selectedCity != null)
                              ...[
                                const Spacer(flex: 1),
                                Select<TransportRoute>(
                                  onTap: (route){
                                    BlocProvider.of<RouteInitializationBloc>(blocContext).add(SelectRoute(route));   
                                  },
                                  defaultValue: 'Elegir Ruta',
                                  items: blocState.cityRoutes,
                                  selected: blocState.selectedRoute,
                                  getTextBySelected: (route) =>
                                    '${route.name} - ${route.description}',
                                  isActive: !blocState.loadingRoutes,
                                  disabledMessage: 'Cargando',
                                  width: inputWidth,
                                  areTheSame: (r1, r2) => r1.uuid == r2?.uuid,
                                  addNew: (){
                                    BlocProvider.of<RouteInitializationBloc>(blocContext).add(InitRouteCreation());
                                  }
                                ),
                                const Spacer(flex: 1),
                                CreationInput(
                                  hintText: 'Placa del vehículo',
                                  controller: blocState.executionLicensePlate,
                                  width: inputWidth,
                                  isAvaible: !blocState.loadingRoutes,
                                ),
                                const Spacer(flex: 1),
                                MaterialButton(
                                  onPressed: !blocState.loadingRoutes? (){
                                    BlocProvider.of<RouteInitializationBloc>(blocContext).add(EndRouteInitialization());
                                  } : null,
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  minWidth: inputWidth,
                                  child: Text(
                                    'Empezar Recorrido',
                                    style: TextStyle(
                                      color: Colors.white
                                    )
                                  )
                                )
                              ],
                            const Spacer(flex: 20),
                          ]
                        )
                      )
                    ),
                    if(blocState is OnCountryCreation)
                      CountryCreationPanel(
                        inputWidth: inputWidth * 0.9
                      ),
                    if(blocState is OnStateCreation)
                      StateCreationPanel(
                        inputWidth: inputWidth * 0.9
                      ),
                    if(blocState is OnCityCreation)
                      CityCreationPanel(
                        inputWidth: inputWidth * 0.9
                      ),
                    if(blocState is OnRouteCreation)
                      RouteCreationPanel(
                        inputWidth: inputWidth * 0.9
                      )
                  ]
                )
              ): Container();
          }
        ),
      )
    );
  }

  void _executePostFrameCallbacks(RouteInitializationState state, BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(state is RoutesInit){
        BlocProvider.of<RouteInitializationBloc>(context).add(Init());
      }else if(state is OnRouteInitialized && (ModalRoute.of(context)?.isCurrent ?? false)){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RouteExecutionScreen(
              route: state.route,
              routeExecution: state.routeExecution
            ),
            maintainState: true,
            allowSnapshotting: false,
            fullscreenDialog: true
          )
        );
      }
    });
  }
}