
import 'package:flutter/material.dart';

class Residente {
  String codResidente;
  String codGarita;
  String direccion;
  String familia;
  String hashId;
  String nombre;
  String documentId;
  String documentIdGarita;

  Residente(
      {this.codResidente,
      this.codGarita,
      this.direccion,
      this.familia,
      this.hashId,
      this.nombre,
      this.documentId,
      this.documentIdGarita});
}



class Campos {
  static String cod_garita = 'cod_garita';
  static String cod_residente = 'cod_residente';
  static String direccion = 'direccion';
  static String familia = 'familia';
  static String documentId = 'documentId';
  static String nombre = 'nombre';
  static String generador_residente = 'generador_residente';
  static String generador_alerta = 'generador_alerta';
  static String document_id_garita = 'document_id_garita';
  static String codigo = 'codigo';
  static String tipo = 'tipo';
  static String duracion = 'duracion';
  static String document_id = 'document_id';

}

class Coleccion {
  static String registro_residente = 'registro_residente';
  static String registro_garita = 'registro_garita';
  static String alerta = 'alerta';
}



class UsAlerta {
  String codigo;
  String duracion;
  String fecha;
  String hashId;
  String tipo;
  String familia;
  String direccion;

  UsAlerta({this.codigo, this.duracion, this.fecha, this.hashId, this.tipo,this.familia,this.direccion});
}



class MyColors{
 static Color sapphire=Color(0xff0A1C66);
 static Color white=Color(0xffFFFFFF);
 static Color moccasin=Color(0xffFDE0B4);
 static Color lavender_blue=Color(0xffC7DBFE);
 static Color grey30=Color(0xff595856);
 static Color grey60=Color(0xff9A9997);
 static Color tory_blue=Color(0xff2B4292);
 static Color white_grey=Color(0xffFEFEFE);
 static Color white_grey_ligth=Color(0xffF9FAF5);
}

class TamanioTexto{
  static double titulo=22.0;
  static double subtitulo=18.0;
  static double texto_pequenio=15.0;
}

class Posiciones{
  static double separacion_inferior_boton=10.0;
  static double obtenerAnchoBotonInferior(context){
    return MediaQuery.of(context).size.width - 20;
  }
}