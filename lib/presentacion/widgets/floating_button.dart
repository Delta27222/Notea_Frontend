import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/Creacion_Edicion_Nota.dart';


class MyFloatingButton extends StatefulWidget {
  final List<Grupo>? grupos;
  const MyFloatingButton({super.key, required Null Function() onPressed, required this.grupos});

  @override
  State<MyFloatingButton> createState() => FloatingButtonState();
}

class FloatingButtonState extends State<MyFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, right: 20),
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: () {
          // Navegar a otra pantalla

          final grupoBloc = BlocProvider.of<GrupoBloc>(context);
          grupoBloc.add(GrupoReload());

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccionesConNota(accion: 'Creando Nota', grupos: widget.grupos)),
          );
        },
        // child: const Icon(Icons.addchart_sharp),
        child: const Icon(Icons.post_add_rounded),
      ),
    );
  }
}

