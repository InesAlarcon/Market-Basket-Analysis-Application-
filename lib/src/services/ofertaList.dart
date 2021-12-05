// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';


class OfertaList{

  String pageid;
  String id;
  String nombre;
  String urlImage;
  int valor;
  String etiquetas;
  String categorias;
  int votos;
  String estado;
  int limiteOferta;
  int limiteUsuario;
  
  OfertaList ({
    this.pageid, this.id, this.nombre, this.urlImage, this.valor, this.etiquetas, this.categorias, this.votos, this.estado, this.limiteOferta, this.limiteUsuario,
  });
  
  OfertaList.fromFirestore(DocumentSnapshot doc)  :
      pageid = doc["idEmpresa"],
      id = doc.id,
      nombre = doc["nombre"],
      urlImage = doc["urlImage"],
      valor = doc["valor"],
      etiquetas = doc["etiquetas"],
      categorias = doc["categorias"],
      votos = doc["votos"],
      estado = doc["estado"],
      limiteOferta = doc["limiteOferta"],
      limiteUsuario = doc["limiteUsuario"];

  @override
  String toString(){
    return "{pageid: ${pageid}, id: ${id}, nombre: ${nombre}, urlImage: ${urlImage}, valor: ${valor}, etiquetas: ${etiquetas}, categorias: ${categorias}, votos: ${votos}, estado: ${estado}, limiteOferta: ${limiteOferta}, limiteUsuario: ${limiteUsuario}}";
  }


  
}
//
// OfertaList.fromFirestore(DocumentSnapshot doc)  =
//
// pageid = doc.get("idEmpresa"),
// id = doc.id,
// nombre = doc.get("nombre"),
// urlImage=doc.get("urlImage"),
// valor= doc.get("valor"),
// etiquetas= doc.get("etiquetas"),
// categorias= doc.get("categorias"),
// votos= doc.get("votos"),
// estado= doc.get("estado"),
// limiteOferta= doc.get("limiteOferta"),
// limiteUsuario= doc.get("limiteUsuario");