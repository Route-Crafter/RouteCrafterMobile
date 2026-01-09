// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routes_mobile/domain/blocs/route_execution/bloc/route_execution_bloc.dart';
import 'package:routes_mobile/domain/entities/routes/route_execution.dart';
import 'package:routes_mobile/domain/entities/routes/transport_route.dart';
import 'package:routes_mobile/globals/injection_container.dart';
import 'package:routes_mobile/screens/app_dimens.dart';
import 'package:routes_mobile/screens/general/loading.dart';
import 'package:routes_mobile/screens/routes/routes_screen.dart';
import 'package:routes_mobile/screens/widgets/general_button.dart';

class RouteExecutionScreen extends StatelessWidget {
  final TransportRoute route;
  final RouteExecution routeExecution;
  const RouteExecutionScreen({
    required this.route,
    required this.routeExecution,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = AppDimens.widthPercentage(0.6, context);
    return BlocProvider(
      create: (_) => sl<RouteExecutionBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<RouteExecutionBloc, RouteExecutionState>(
            builder: (blocContext, blocState) {
              _managePostFrameCallBacks(blocContext, blocState);
              return blocState is OnRouteExecution? 
                SizedBox(
                  width: AppDimens.widthPercentage(1, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(blocState.status == RouteExecutionStatus.ended)
                        ...[
                          const Spacer(flex: 2),
                          Text(
                            'Ruta terminada exitosamente',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const Spacer(flex: 2)
                        ],
                      SizedBox(
                        height: blocState.status == RouteExecutionStatus.ended?
                          AppDimens.widthPercentage(
                            0.95,
                            context
                          ): AppDimens.heightPercentage(
                            0.65,
                            context
                          ),
                        width: AppDimens.widthPercentage(
                            blocState.status == RouteExecutionStatus.ended?
                              0.95:
                              1,
                            context
                          ),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 8,
                                spreadRadius: 0.5,
                                color: Theme.of(context).colorScheme.shadow.withOpacity(0.5)
                              )
                            ],
                            borderRadius: _getMapRadius(blocState)
                          ),
                          child: ClipRRect(
                            borderRadius: _getMapRadius(blocState),
                            child: GoogleMap(
                              onMapCreated: (controller){
                                BlocProvider.of<RouteExecutionBloc>(blocContext).add(InitRouteExecutionProccess(
                                  mapController: controller
                                ));
                              },
                              markers: {
                                if(blocState.status != RouteExecutionStatus.ended)
                                  blocState.positionMarker,
                                if(blocState.status == RouteExecutionStatus.ended)
                                  ...[
                                    Marker(
                                      markerId: MarkerId('route_init'),
                                      position: LatLng(
                                        blocState.wayPoints.first.lat,
                                        blocState.wayPoints.first.lon
                                      ),
                                      icon: blocState.routeInitImage!
                                    ),
                                    Marker(
                                      markerId: MarkerId('route_end'),
                                      position: LatLng(
                                        blocState.wayPoints.last.lat,
                                        blocState.wayPoints.last.lon
                                      ),
                                      icon: blocState.routeEndImage!
                                    )
                                  ]
                              },
                              polylines: {
                                if(blocState.routePolyline != null)
                                  blocState.routePolyline!.copyWith(
                                    colorParam: Theme.of(context).colorScheme.primary
                                  )
                              },
                              initialCameraPosition: CameraPosition(
                                target: blocState.positionMarker.position,
                                zoom: 16
                              )
                            )
                          )
                        )
                      ),
                      const Spacer(flex: 5),
                      Text(
                        blocState.route.name,
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                      Text(
                        blocState.route.description,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                      if(blocState.routeExecution.licensePlate.isNotEmpty)
                        ...[
                          const SizedBox(
                            height: 5
                          ),
                          Container(
                            width: buttonWidth * 0.5,
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 12
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryFixedDim,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              blocState.routeExecution.licensePlate,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ],
                      const Spacer(flex: 2),
                      if(blocState.status == RouteExecutionStatus.ended)
                        GeneralButton(
                          name: 'Continuar',
                          width: buttonWidth,
                          onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RoutesScreen(),
                                maintainState: true,
                                allowSnapshotting: false,
                                fullscreenDialog: true
                              )
                            );
                          }
                        ),
                      if(blocState.status != RouteExecutionStatus.ended)
                        GeneralButton(
                          name: 'Finalizar Ruta',
                          width: buttonWidth,
                          onPressed: (){
                            BlocProvider.of<RouteExecutionBloc>(blocContext).add(EndRouteExecutionProccess());
                          }
                        ),
                      const Spacer(flex: 4)
                    ]
                  ),
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

  BorderRadius _getMapRadius(OnRouteExecution blocState) => BorderRadius.only(
    bottomLeft: _getBottomRadiusByStatus(
      blocState.status
    ),
    bottomRight: _getBottomRadiusByStatus(
      blocState.status
    ),
    topLeft: _getTopRadiusByStatus(
      blocState.status
    ),
    topRight: _getTopRadiusByStatus(
      blocState.status
    )
  );

  Radius _getBottomRadiusByStatus(RouteExecutionStatus status) =>
    Radius.circular(
      status == RouteExecutionStatus.ended?
        250:
        20
    );

  Radius _getTopRadiusByStatus(RouteExecutionStatus status) =>
    Radius.circular(
      status == RouteExecutionStatus.ended?
        250:
        0
    );

  void _managePostFrameCallBacks(BuildContext context, RouteExecutionState state){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(state is RouteExecutionInitial){
        BlocProvider.of<RouteExecutionBloc>(context).add(StartBloc(
          route: route,
          routeExecution: routeExecution
        ));
      }
    });
  }
}