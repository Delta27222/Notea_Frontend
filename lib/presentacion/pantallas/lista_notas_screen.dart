// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/VONota/EstadoEnum.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/home_screen.dart';
import 'package:notea_frontend/presentacion/widgets/card.dart';
import 'package:notea_frontend/presentacion/widgets/desplegable.dart';

import '../../dominio/agregados/usuario.dart';

// ignore: must_be_immutable
class MyDropdown extends StatefulWidget {
  List<Grupo>? grupos;
  final Usuario usuario;

  MyDropdown({super.key, required this.grupos, required this.usuario});

  @override
  // ignore: library_private_types_in_public_api
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  List<Nota>? notas = [];
  String cantNotas = '';

  Map<String, dynamic> cont = {
    "contenido":[
      {
          "texto":{
            "cuerpo":"<p>​Wwewwww</p>"
          }
      },
      {
          "texto":{
            "cuerpo":"<b>​Essseeeeee</b>"
          }
      }
    ]
  };

  Map<String, dynamic> contenido = {              //Este se supone sera lo que traiga el contenido de la nota
    "contenido": [
      {
        "texto": {
          "cuerpo": "Este es un texto con estilo 1"
        }
      },
      {
        "texto": {
          "cuerpo": "Este es un texto con estilo 2"
        }
      },
      {
        "tarea": {
          "value": [
            {
              "id": {
                "id": "c75b914c-4e14-4a92-8462-28ea357b5b3e"
              },
              "titulo": "Contenido Tarea 1 de 1",
              "check": true
            },
            {
              "id": {
                "id": "c1151004-e0b9-4177-a222-4b90d402f38e"
              },
              "titulo": "Contenido Tarea 1 de 2",
              "check": false
            }
          ],
          "assigned": true
        }
      },
      {
        "texto": {
          "cuerpo": "Este es un texto con estilo 3"
        }
      },
      {
        "tarea": {
          "value": [
            {
              "id": {
                "id": "ae01c6b6-b69b-4011-a1b0-8eb9602b4378"
              },
              "titulo": "Contenido Tarea 2 de 1",
              "check": false
            },
            {
              "id": {
                "id": "a471a6b1-5b06-4c0c-afeb-aeec7dc4e37b"
              },
              "titulo": "Contenido Tarea 2 de 2",
              "check": true
            }
          ],
          "assigned": true
        }
      }
    ],
    "assigned": true
  };

  Map<String, dynamic> convertStringToMap(String jsonString) {
    return jsonDecode(jsonString);
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notaBloc = BlocProvider.of<NotaBloc>(context);
      notaBloc.add(NotaCatchEvent(grupos: widget.grupos!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotaBloc, NotaState>(builder: (context, state) {
      if (state is NotasCatchSuccessState) {
        notas = state.notas;

        List<Grupo> gruposPapelera = [];
        int cantNotasTotal = 0;
        for (int i = 0; i < widget.grupos!.length; i++) {
          final grupo = widget.grupos![i]; //Tenemos el grupo que se renderizará
          final cant = notas
              ?.where((nota) =>
                  nota.idGrupo.getIdGrupoNota() == grupo.idGrupo &&
                  !(nota.getEstado() == "PAPELERA"))
              .toList();
          cantNotasTotal += cantNotasTotal + cant!.length;
          if (cant!.isNotEmpty) {
            gruposPapelera.add(widget.grupos![i]);
          }
        }



      // print('----------------------cantNas');
      //   print(cantNotasTotal);
      //   print('----------------------cantNas');
        


      //             Column(
      //               children: [
      //                 Container(
      //                   width: MediaQuery.of(context).size.width / 2, // Ancho igual a la mitad de la pantalla
      //                   height: MediaQuery.of(context).size.height / 2, // Alto igual a la mitad de la pantalla
      //                   decoration: const BoxDecoration(
      //                     image: DecorationImage(
      //                       image: AssetImage('assets/images/notes_not_found.png'),
      //                       fit: BoxFit.contain,
      //                     ),
      //                   ),
      //                 ),
      //               ],
                  // );





        return ListView.builder(
            itemCount: gruposPapelera.length,
            itemBuilder: (context, index) {
              final grupo =
                  gruposPapelera[index]; //Tenemos el grupo que se renderizará
              final notasDeGrupo = notas
                  ?.where((nota) =>
                      nota.getIdGrupoNota() == grupo.idGrupo &&
                      !(nota.getEstado() == "PAPELERA"))
                  .toList();
              if (notasDeGrupo != null && notasDeGrupo.isNotEmpty) {
                return FractionallySizedBox(
                  widthFactor: 0.9, // Establece
                  child: Column(
                    children: <Widget>[
                      Tooltip(
                        message: grupo.idGrupo,
                        child: Desplegable(
                          titulo: grupo.nombre.nombre,
                          contenido: Column(
                              children: notasDeGrupo.map((nota) {
                            return SizedBox(
                                child: CartaWidget(
                                  idNota: nota.id,
                                  habilitado: false,
                                  fecha: nota.getFechaCreacion(),
                                  titulo: nota.titulo.tituloNota,
                                  // contenidoTotal1: cont,
                                  contenidoTotal1: convertStringToMap(nota.getContenido()),         //Esto hace que se me muera toda la aplicacion
                                  tags: const ['Tag1', 'Tag2', 'Tag3sssssss'],
                                  onDeletePressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirmación'),
                                          content: const Text(
                                              '¿Estás seguro de que deseas mover a la papelera?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Cerrar el cuadro de diálogo
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Aceptar'),
                                              onPressed: () {
                                                BlocProvider.of<NotaBloc>(context)
                                                    .add(ModificarEstadoNotaEvent(
                                                        idNota: nota.id,
                                                        estado: "PAPELERA"));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MessagesScreen(
                                                              usuario:
                                                                  widget.usuario,
                                                            )
                                                          )
                                                        );
                                                // mover a la papelera
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    // Lógica para eliminar la nota
                                  },
                                  onChangePressed: null,
                            ));
                          }).toList()),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Separación entre los desplegables
                    ],
                  ),
                );
              }
            });
      } else {
        // No mostrar el grupo si no tiene notas que pertenecen a él
        return const SizedBox.shrink();
      }
    });
  }
}

          // notas?.forEach((nota) {
          //   print('Título: ${nota.titulo.tituloNota}');
          //   print('Contenido: ${nota.contenido.contenidoNota}');
          //   print('Fecha de creación: ${nota.fechaCreacion}');
          //   print('Estado: ${nota.estado.name}');
          //   print('Ubicación Latitud: ${nota.ubicacion.latitud}');
          //   print('Ubicación Longitud: ${nota.ubicacion.longitud}');
          //   print('ID: ${nota.id}');
          //   print('---------------------');
          // });
          // print('--------------------------');
          // print('--------------------------');

                  //   notasDeGrupo?.forEach((nota) {
                  //   print('Título: ${nota.titulo.tituloNota}');
                  //   print('Contenido: ${nota.contenido.contenidoNota}');
                  //   print('Fecha de creación: ${nota.fechaCreacion}');
                  //   print('Estado: ${nota.estado.name}');
                  //   print('Ubicación Latitud: ${nota.ubicacion.latitud}');
                  //   print('Ubicación Longitud: ${nota.ubicacion.longitud}');
                  //   print('ID grupo: ${nota.idGrupo.getIdGrupoNota()}');
                  //   print('ID: ${nota.id}');
                  //   print('---------------------');
                  // });


