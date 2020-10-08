import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:residente/models/residente.dart';
import 'package:residente/models/times.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/models/types.dart';
import 'package:residente/screens/end.dart';
import 'package:residente/screens/home.dart';
import 'package:residente/utils/methos.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

String codigo_ejemplo = '1234';
String tipo_visita_ejemplo = 'Amigos';

class Explicacion extends StatefulWidget {
  final String title = "Alerta";
  @override
  ExplicacionState createState() => ExplicacionState();
}

class ExplicacionState extends State<Explicacion> {
  TutorialCoachMark tutorialCoachMark;
  int indexSelected = 1;

  List<TargetFocus> targets = List();

  GlobalKey keyTiempo1 = GlobalKey();
  GlobalKey keyTipoVisita1 = GlobalKey();

  @override
  void initState() {
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.black,
        textSkip: "SALTAR TUTORIAL",
        paddingFocus: 10,
        opacityShadow: 0.8, onFinish: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExpEnd()),
      );
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print("skip");
    })
      ..show();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyTiempo1,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Selecciona el tiempo de espera",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Aqui debes seleccionar el tiempo de espera en el que crees que llegará tu visita.",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyTipoVisita1,
        color: Colors.black,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Tipo de visita",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Selecciona el tipo de visita que estas esperando.",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tu Nombre De Ejemplo',
            //'Darwin Cabezas',
            style: TextStyle(color: MyColors.white),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: MyColors.sapphire,
          elevation: 0.0,
        ),
        body: _inicio(),
        backgroundColor: MyColors.sapphire,
      ),
    );
  }

  _inicio() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        _cardSuperior(),
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Tiempo de espera',
                    style: TextStyle(
                        color: MyColors.white,
                        fontSize: TamanioTexto.subtitulo,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        _cardMedia(),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Tipo de visita',
            style: TextStyle(
                color: MyColors.white,
                fontSize: TamanioTexto.subtitulo,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: _cardInf(),
        ),
      ],
    );
  }

  /*_inicio() {
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              key: keyButton,
              color: Colors.blue,
              height: 100,
              width: MediaQuery.of(context).size.width - 50,
              child: Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  color: Colors.blueAccent,
                  child: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    showTutorial();
                  },
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 50,
            height: 50,
            child: RaisedButton(
              key: keyButton1,
              onPressed: () {},
            ),
          ),
        ),
      ],
    ));
  }*/

  _cardSuperior() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          color: MyColors.sapphire,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 0.0,
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Center(
                child: Container(
                  child: Image(
                    image: AssetImage("assets/images/g0.png"),
                    width: 150,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 0.0,
            ),
            Text(
              '',
              style: TextStyle(
                  color: MyColors.white,
                  fontSize: TamanioTexto.subtitulo,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ));
  }

  _cardMedia() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: MyColors.white,
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              height: 120.0,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 10.0, top: 0.0),
                scrollDirection: Axis.horizontal,
                itemCount: times.length,
                itemBuilder: (BuildContext contex, int index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildCircleAvatar(index),
                      ],
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }

  _buildCircleAvatar(int index) {
    return Container(
      child: (indexSelected == index)
          ? GestureDetector(
              onTap: () {
                setState(() {
                  indexSelected = index;
                });
              },
              child: Container(
                key: keyTiempo1,
                child: CircleAvatar(
                  radius: 45.0,
                  backgroundColor: MyColors.moccasin,
                  child: Text(
                    times[index].toString(),
                    style: TextStyle(
                        fontSize: 40,
                        color: MyColors.sapphire,
                        fontWeight: FontWeight.bold), //Colors.white),
                  ),
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  indexSelected = index;
                });
              },
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: MyColors.sapphire,
                child: Text(
                  times[index].toString(),
                  style: TextStyle(fontSize: 30, color: MyColors.white),
                ),
              ),
            ),
    );
  }

  _cardInf() {
    GlobalKey mykey = GlobalKey();
    return Container(
      color: MyColors.white_ligth,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: type.length,
        itemBuilder: (BuildContext context, int index) {
          final String tipo = type[index].toString();
          if (index != null) {
            if (index == 1)
              mykey = keyTipoVisita1;
            else
              mykey = new GlobalKey();
          }
          return GestureDetector(
            onTap: () {
              //_setAlertData(null, type[index], null);
              try {
                //_next(context);

              } catch (ex) {
                Methods.guardarLogCloudStore('home', '_cardInf', ex.toString());
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: MyColors.white,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 10),
                  child: Container(
                    key: mykey,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(color: MyColors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Center(
                              child: Text(
                                tipo,
                                style: TextStyle(
                                    color: MyColors.sapphire,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }
}

//******************************************** */

class ExpEnd extends StatefulWidget {
  @override
  _ExpEndState createState() => _ExpEndState();
}

class _ExpEndState extends State<ExpEnd> {
  TutorialCoachMark tutorialCoachMark;

  List<TargetFocus> targets = List();

  GlobalKey keyLinear = GlobalKey();
  GlobalKey keyTipoVisita1 = GlobalKey();
  GlobalKey keyCodigo = GlobalKey();
  GlobalKey keyEnviarAlerta = GlobalKey();

  @override
  void initState() {
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.black,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8, onFinish: () {
      localDb.save(Campos.tutorial_realizado, 'true');
      _mostrarPopUp(context);
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print("skip");
    })
      ..show();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyLinear,
        color: Colors.black,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Caducidad de alerta",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Tu alerta puede caducar en cualquier momento antes de ser enviada.",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: 120,
                        child: FlatButton(
                          color: Colors.white,
                          child: Text(
                            'Lo tengo',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          onPressed: () {
                            tutorialCoachMark.next();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyCodigo,
        color: Colors.black,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Código de visita",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Este es el código que debes compartir con tu visitante.",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: 120,
                        child: FlatButton(
                          color: Colors.white,
                          child: Text(
                            'Lo tengo',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          onPressed: () {
                            tutorialCoachMark.next();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyEnviarAlerta,
        color: Colors.black,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Envia la alerta",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Ahora puedes enviar tu alerta para que puedan verla en garita.",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        body: _body(context),
        backgroundColor: MyColors.sapphire,
      ),
    );
  }

  _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          key: keyLinear,
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    child: LinearPercentIndicator(
                        animation: true,
                        lineHeight: 4.0,
                        animationDuration: 10000,
                        percent: 1.0,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: MyColors.moccasin),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Alerta lista!',
                      style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: TamanioTexto.subtitulo,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Envia la alerta antes que esta se cancele.',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: TamanioTexto.texto_pequenio,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        //),

        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  key: keyCodigo,
                  child: Text(
                    codigo_ejemplo,
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: MyColors.white),
                  ),
                ),
                Text(
                  'Comparte este código  ',
                  style: TextStyle(
                      fontSize: TamanioTexto.subtitulo,
                      color: Colors.grey[400]),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Tipo Visita:  ',
                      style: TextStyle(
                          fontSize: TamanioTexto.subtitulo,
                          color: Colors.grey[300]),
                    ),
                    Text(
                      tipo_visita_ejemplo,
                      style: TextStyle(
                          fontSize: TamanioTexto.subtitulo,
                          color: Colors.grey[300]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Builder(
            builder: (context) => Center(
              child: Container(
                key: keyEnviarAlerta,
                width: Posiciones.getBottomButtonSize(context),
                height: 50.0,
                child: FlatButton(
                  color: MyColors.white,
                  onPressed: () {},
                  child: Text(
                    'ENVIAR',
                    style:
                        TextStyle(letterSpacing: 1.5, color: MyColors.sapphire),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(22.0),
                    side: BorderSide(color: MyColors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: Posiciones.separacion_inferior_boton,
        ),
      ],
    );
  }

  _mostrarPopUp(
    context,
  ) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(color: MyColors.sapphire),
    );

    return Alert(
      style: alertStyle,
      context: context,
      //type: AlertType.success,
      title: "Genial! ahora sabes como usar alert, para emitir alertas.",
      buttons: [
        DialogButton(
            child: Text(
              "Enviar alerta real",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
            color: MyColors.sapphire),
        DialogButton(
          child: Text(
            "Salir",
            style: TextStyle(color: MyColors.sapphire, fontSize: 20),
          ),
          onPressed: () => SystemNavigator.pop(),
          color: MyColors.white,
        )
      ],
    ).show();
  }
}
