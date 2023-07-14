// ignore_for_file: empty_constructor_bodies

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/infraestructura/Repositorio/repositorioEtiquetaImpl.dart';
import 'package:notea_frontend/infraestructura/api/remoteDataEtiqueta.dart';

part 'etiqueta_event.dart';
part 'etiqueta_state.dart';

class EtiquetaBloc extends  Bloc<EtiquetaEvent, EtiquetaState> {

  EtiquetaBloc() : super(const EtiquetaInitialState()){

    on<EtiquetaCatchEvent>((event, emit) async {
      emit(const EtiquetaInitialState());
      final repositorio = RepositorioEtiquetaImpl(remoteDataSource: RemoteDataEtiquetaImp(client: http.Client()));
      final etiquetas = await repositorio.buscarEtiquetas(event.idUsuarioDueno);
      await Future.delayed(const Duration(milliseconds: 300));
      etiquetas.isLeft() ?  emit(EtiquetasSuccessState(etiquetas: etiquetas.left!)): emit(const EtiquetasFailureState());  //Se mite el estado de SUCCESS o FAILURE
    });
  }
}

