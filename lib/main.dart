import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:residente/screens/home.dart';
import 'package:residente/screens/noConnection.dart';
import 'package:residente/screens/start.dart';
import 'package:residente/utils/localStorageDB.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'models/residente.dart';

void main() => runApp(MyApp());

final localDb = LocalDataBase();
Residente residente = new Residente();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '...',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Main(),
    );
  }
}

class Main extends StatelessWidget {
  _testConnection(context) async {
    var hasConnection = await DataConnectionChecker().hasConnection;

    if (hasConnection) {
      _getStart(context);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoConnection()));
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Image(image: AssetImage("assets/images/campana.png")),
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
    } catch (e) {}
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
