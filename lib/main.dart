import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:residente/screens/InicioScreen.dart';
import 'package:residente/screens/sinConexionScreen.dart';
import 'package:residente/screens/start.dart';
import 'package:residente/utils/localStorageDB.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'models/residenteModel.dart';

void main() => runApp(MyApp());

final baseLocal = BaseDatosLocal();
ResidenteModel residenteM = new ResidenteModel();

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
  _probarConexion(context) async {
    var tieneConexion = await DataConnectionChecker().hasConnection;

    if (tieneConexion) {
      _iniciar(context);
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SinConexionScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    _probarConexion(context);
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
            child: Image(image: AssetImage("assets/images/campana.png")),
          ),
        ),
      ),
      backgroundColor: MyColors.sapphire,
    );
  }

  _iniciar(context) {
    try {
      baseLocal.leer(Campos.cod_residente).then(
        (data) {
          if (data != null) {
            residenteM.codResidente = data;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );

            _cargarDatosUsuario();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Start()),
            );
          }
        },
      );
    } catch (e) {}
  }

  _cargarDatosUsuario() {
    baseLocal.leer(Campos.document_id).then((data) {
      residenteM.documentId = data;
      global.residente = residenteM;
    });

    baseLocal.leer(Campos.nombre).then((data) {
      residenteM.nombre = data;
      global.residente = residenteM;
    });

    baseLocal.leer(Campos.document_id_garita).then((data) {
      residenteM.documentIdGarita = data;
      global.residente = residenteM;
    });

    baseLocal.leer(Campos.familia).then((data) {
      residenteM.familia = data;
      global.residente = residenteM;
    });

    baseLocal.leer(Campos.direccion).then((data) {
      residenteM.direccion = data;
      global.residente = residenteM;
    });
  }
}
