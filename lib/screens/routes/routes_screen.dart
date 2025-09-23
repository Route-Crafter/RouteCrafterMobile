// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routes_mobile/data/adapters/data_formatter.dart';
import 'package:routes_mobile/domain/blocs/routes/routes_bloc.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/globals/injection_container.dart';
import 'package:routes_mobile/screens/app_dimens.dart';
import 'package:routes_mobile/screens/general/loading.dart';
import 'package:routes_mobile/screens/route_initialization/route_initialization_screen.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/select.dart';
import 'package:routes_mobile/screens/widgets/general_button.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonWidth = AppDimens.widthPercentage(0.6, context);
    return BlocProvider(
      create: (_) => sl<RoutesBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<RoutesBloc, RoutesState>(
            builder: (blocContext, blocState) {
              _managePostFrameCallBacks(blocContext, blocState);
              return blocState is OnRoutesMap? 
                Column(
                  children: [
                    Container(
                      height: AppDimens.heightPercentage(0.7, context),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 8,
                            spreadRadius: 0.5,
                            color: Theme.of(context).colorScheme.shadow.withOpacity(
                              blocState.mapController != null?
                                0.5:
                                0.1
                            )
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)
                        )
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)
                        ),
                        child: GoogleMap(
                          onMapCreated: (controller){
                            BlocProvider.of<RoutesBloc>(blocContext).add(LoadMapInitialization(
                              controller: controller
                            ));
                          },
                          onCameraMove: (newPosition){
                            BlocProvider.of<RoutesBloc>(blocContext).add(UpdateMapPosition(
                              position: newPosition.target
                            ));
                          },
                          markers: {
                            blocState.devicePosition
                          },
                          polylines: {
                            if(blocState.selectedExecution == null)
                              if(blocState.routePolyline != null && blocState.routePolyline!.points.isNotEmpty)
                                blocState.routePolyline!
                              else
                                ...blocState.executionsPolylines
                            else
                              blocState.executionsPolylines.firstWhere(
                                (pl) => pl.mapsId.value == '${blocState.selectedExecution!.id}'
                              ).copyWith(
                                widthParam: 8
                              )
                          },
                          initialCameraPosition: CameraPosition(
                            target: blocState.devicePosition.position,
                            zoom: 16
                          )
                        )
                      )
                    ),
                    if(blocState.place.city != null)
                      ...[
                        const Spacer(flex: 1),
                        Select<TransportRoute>(
                          onTap: (route){
                            BlocProvider.of<RoutesBloc>(blocContext).add(SelectRoute(
                              route,
                              Theme.of(context).colorScheme.primary
                            ));
                          },
                          defaultValue: 'Seleccionar Ruta',
                          items: blocState.routes,
                          selected: blocState.selectedRoute,
                          getTextBySelected: (route) => '${route.name} - ${route.description}',
                          isActive: !blocState.loadingRoutes && blocState.routes.isNotEmpty,
                          disabledMessage: blocState.loadingRoutes?
                            'Cargando rutas':
                            'No hay rutas aquí',
                          width: buttonWidth,
                          areTheSame: (r1, r2) => r1.uuid == r2?.uuid
                        ),
                        if(blocState.selectedRoute != null)
                          ...[
                            const Spacer(flex: 1),
                            Select<RouteExecution>(
                              onTap: (execution){
                                BlocProvider.of<RoutesBloc>(blocContext).add(SelectRouteExecution(execution));
                              },
                              defaultValue: 'Seleccionar Recorrido',
                              items: blocState.selectedRoute!.executions,
                              selected: blocState.selectedExecution,
                              getTextBySelected: (exc) => '${sl<DataFormatter>().getStringFromDate(exc.initTime)} - ${exc.licensePlate}',
                              isActive: blocState.selectedRoute!.executions.isNotEmpty,
                              disabledMessage: 'Ruta sin recorridos',
                              width: buttonWidth,
                              areTheSame: (e1, e2) => e1.id == e2?.id
                            )
                          ]
                      ],
                      const Spacer(flex: 5),
                      GeneralButton(
                        name: 'Iniciar Recorrido',
                        width: buttonWidth,
                        onPressed: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RouteInitializationScreen(),
                              maintainState: true,
                              allowSnapshotting: false,
                              fullscreenDialog: true
                            )
                          );
                        }
                      ),
                      const Spacer(flex: 1)
                  ]
                ):
                Center(
                  child: Loading()
                );
            }
          )
        )
      ),
    );
  }

  void _managePostFrameCallBacks(BuildContext context, RoutesState state){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(state is RoutesInitial){
        BlocProvider.of<RoutesBloc>(context).add(InitBloc());
      }
    });
  }
}