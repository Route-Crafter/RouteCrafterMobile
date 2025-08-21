import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routes_mobile/domain/blocs/route_initialization/route_initialization_bloc.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/creation_input.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/creation_panel.dart';
class RouteCreationPanel extends StatelessWidget {
  final double inputWidth;
  const RouteCreationPanel({
    required this.inputWidth, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final blocState = BlocProvider.of<RouteInitializationBloc>(context).state as OnRouteCreation;
    return CreationPanel(
      child: Column(
        children: [
          Text(
            'Ingresa una nueva ruta',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 15
          ),
          CreationInput(
            hintText: 'Nombre',
            controller: blocState.name,
            width: inputWidth
          ),
          const SizedBox(
            height: 10
          ),
          CreationInput(
            hintText: 'Descripción',
            controller: blocState.description,
            width: inputWidth
          ),
          const SizedBox(
            height: 10
          ),
          MaterialButton(
            onPressed: (){
              BlocProvider.of<RouteInitializationBloc>(context).add(EndRouteCreation());
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            color: Theme.of(context).primaryColor,
            minWidth: inputWidth,
            child: const Text(
              'Crear',
              style: TextStyle(
                color: Colors.white
              )
            )
          )
        ]
      )
    );
  }
}