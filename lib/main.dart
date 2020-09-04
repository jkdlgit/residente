import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:residente/screens/home.dart';
import 'package:residente/screens/noConnection.dart';
import 'package:residente/screens/start.dart';
import 'package:residente/screens/versionInactiva.dart';
import 'package:residente/utils/localStorageDB.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/utils/methos.dart';
import 'models/residente.dart';

void main() => runApp(MyApp());

final localDb = LocalDataBase();
Residente residente = new Residente();
final db = Firestore.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '...',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainHome(),
    );
  }
}

class MainHome extends StatelessWidget {
  _testConnection(context) async {
    var hasConnection = await DataConnectionChecker().hasConnection;

    _gestionarEstadoVersion();
    print('>>>>>>>>>>>>>>>>>>>>>> A LA ESPERA DE FINALIZACION');

    if (hasConnection) {
      bool ret = await _versionEstaActiva();
      if (ret) {
        _getStart(context);
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VersionInactiva()));
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoConnection()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Methods.guardarLogCloudStore('main', 'build', 'tercer error');
    _testConnection(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.sapphire,
        elevation: 0.0,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.3,
          heightFactor: 0.3,
          child: Container(
            child: Image(image: AssetImage("assets/images/g0.png")),
          ),
        ),
      ),
      backgroundColor: MyColors.sapphire,
    );
  }

  _getStart(context) {
    try {
      localDb.read(Campos.cod_residente).then(
        (data) {
          if (data != null) {
            residente.codResidente = data;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );

            _getData();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Start()),
            );
          }
        },
      );
    } catch (ex) {
      Methods.guardarLogCloudStore('main', '_getStart', ex.toString());
    }
  }

  //verificar contra la base local
  Future<bool> _versionEstaActiva() async {
    bool ret = true;

    try {
      var data = await localDb.read(Campos.estado_version);
      if (data != null) {
        if (data.toLowerCase() != 'true') {
          ret = false;
        }
      }
    } catch (ex) {
      Methods.guardarLogCloudStore('main', '_versionEstaActiva', ex.toString());
    }
    print('>>>>>>>>>>>>>>>>>>>>>> ESTADO LOCAL DE VERSION:  ' + ret.toString());

    return ret;
  }

  _gestionarEstadoVersion() async {
    bool state = true;
    try {
      CollectionReference userQuery = db
          .collection(Coleccion.configuracion)
          .document('version_inactiva')
          .collection('versiones');

      QuerySnapshot qsna = await userQuery.getDocuments();

      print('>>>>>>>>>>>>>>>>>>>>>>FINALIZO EL METODO DE GESTION DE VERSION');

      if (qsna.documents.length > 0) {
        for (int i = 0; i < qsna.documents.length; i++) {
          String v = qsna.documents[i]['version'];
          if (qsna.documents[i]['version'] == global.mi_version) {
            state = false;
          }
        }
        //state = true;
      }
    } catch (ex) {
      Methods.guardarLogCloudStore('main', '_versionEstaActiva', ex.toString());
      state = true;
    }
    print(
        '>>>>>>>>>>>>>>>>>>>>>>FINALIZO EL METODO DE GESTION DE VERSION Y TIENE :  ' +
            state.toString());

    localDb.save(Campos.estado_version, state.toString());
  }

  _getData() {
    localDb.read(Campos.document_id).then((data) {
      residente.documentId = data;
      global.residente = residente;
    });

    localDb.read(Campos.nombre).then((data) {
      residente.nombre = data;
      global.residente = residente;
    });

    localDb.read(Campos.document_id_garita).then((data) {
      residente.documentIdGarita = data;
      global.residente = residente;
    });

    localDb.read(Campos.familia).then((data) {
      residente.familia = data;
      global.residente = residente;
    });

    localDb.read(Campos.direccion).then((data) {
      residente.direccion = data;
      global.residente = residente;
    });
  }
}
