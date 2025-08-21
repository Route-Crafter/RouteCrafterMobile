import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routes_mobile/domain/blocs/route_initialization/route_initialization_bloc.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/creation_input.dart';
import 'package:routes_mobile/screens/route_initialization/widgets/creation_panel.dart';
class CountryCreationPanel extends StatelessWidget {
  final double inputWidth;
  const CountryCreationPanel({
    required this.inputWidth,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final blocState = BlocProvider.of<RouteInitializationBloc>(context).state as OnCountryCreation;
    return CreationPanel(
      child: Column(
        children: [
          Text(
            'Ingresa un nuevo país',
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
            hintText: 'Código ISO',
            controller: blocState.iso,
            width: inputWidth
          ),
          const SizedBox(
            height: 10
          ),
          MaterialButton(
            onPressed: (){
              BlocProvider.of<RouteInitializationBloc>(context).add(EndCountryCreation());
            },
            minWidth: inputWidth,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            color: Theme.of(context).primaryColor,
            child: const Text(
              'Crear',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          )
        ]
      )
    );
  }
}