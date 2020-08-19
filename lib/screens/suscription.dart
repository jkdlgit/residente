import 'dart:async';
import 'dart:io';

//import 'package:align_positioned/align_positioned.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:residente/library/variables_globales.dart' as global;
import 'package:residente/main.dart';
import 'package:residente/models/residente.dart';
import 'package:residente/screens/home.dart';
import 'package:residente/screens/register2.dart';
import 'package:residente/screens/suscriptionTankyou.dart';
import 'package:residente/utils/localStorageDB.dart';
import 'package:residente/utils/methos.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Suscription extends StatefulWidget {
  @override
  _SuscriptionState createState() => _SuscriptionState();
}

final localDb = LocalDataBase();
final db = Firestore.instance;
StreamSubscription purchaseUpdatedSubscription;
StreamSubscription purchaseErrorSubscription;
StreamSubscription conectionSubscription;

class _SuscriptionState extends State<Suscription> {
  final myController = TextEditingController();
  ProgressDialog pr;
  bool codeState = true;
  String platformVersion = 'Unknown';
  List<IAPItem> _itemsSuscription = [];
  List<IAPItem> _itemsProducts = [];
  //List<IAPItem> _itemsSus = [];
  //List<PurchasedItem> _purchases = [];
  //List<PurchasedItem> _purchasesSus = [];
  //bool purchace_ready = false;

  /*final List<String> _productLists = ["pluma_test"];*/
  final List<String> _suscriptionLists = Platform.isAndroid
      ? [
          'android.test.purchased',
          'point_1000',
          '5000_point',
          'android.test.canceled',
          'pluma_test',
          'tv',
          'telefono',
          'internet',
        ]
      : ['com.cooni.point1000', 'com.cooni.point5000'];
  final List<String> _productLists = Platform.isAndroid
      ? [
          'android.test.purchased',
          'point_1000',
          '5000_point',
          'android.test.canceled',
          'pluma_test',
          'lapiz',
          'mouse',
          'pelota',
        ]
      : ['com.cooni.point1000', 'com.cooni.point5000'];

  @override
  initState() {
    super.initState();
    _initInappPurchase(context);
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    //print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      platformVersion = platformVersion;
    });

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      //print('consumeAllItems: $msg');
    } catch (err) {
      //ingresa aqui cuando no encuentra productos o suscripciones
      //print('consumeAllItems error: $err');
    }

    conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      //print('connected: $connected');
    });

    purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      Contenedor.suscripcionActiva = false;
      //global.isSuscribed = false;
      if (productItem.productId == global.suscriptionName) {
        //global.isSuscribed = true;
        Contenedor.suscripcionActiva = true;
        localDb.save(Dato.estadoCaducado, 'Flase');
        _guardarSuscripcionActiva();
        _continuar(context);
      }
      //print('purchase-updated: $productItem');
    });

    purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      //purchaseError.responseCode:7 significa que el producto o suscripcion
      //ya fue adquirid@

      Contenedor.suscripcionActiva = false;
      //Codigo de error 7 significa que el producto ya ha sido comprado o ya se ha suscripto
      if (purchaseError.responseCode == 7) {
        //global.isSuscribed = true;
        Contenedor.suscripcionActiva = true;
        localDb.save(Dato.estadoCaducado, 'Flase');
        _guardarSuscripcionActiva();
        _continuar(context);
      }
      //print('purchase-error: $purchaseError');
    });
  }

  Widget build(BuildContext context) {
    //if (purchace_ready) {}

    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: SafeArea(child: body(context)),
        backgroundColor: MyColors.white_grey,
      ),
    );
  }

  Widget body(context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: 50.0,
                        height: 60.0,
                        child: SizedBox(
                          width: 20.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 45.0,
                      child:
                          Image(image: AssetImage("assets/images/reloj.png")),
                    )
                  ],
                ),
                Text(
                  'Suscríbete Hoy',
                  style: TextStyle(
                    color: MyColors.sapphire,
                    fontSize: TamanioTexto.logo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ayúdanos a innovar',
                  style: TextStyle(
                    color: MyColors.grey30,
                    fontSize: TamanioTexto.texto_pequenio,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: 60.0,
                        height: 15.0,
                        child: SizedBox(
                          width: 30.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 25.0,
                      child:
                          Image(image: AssetImage("assets/images/directo.png")),
                    )
                  ],
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
                  child: Container(
                    child: Image(image: AssetImage("assets/images/caja.png")),
                  ),
                ),
                /*        AlignPositioned(
                    child:
                        Image(image: AssetImage("assets/images/directo.png")),
                    alignment: Alignment.topLeft,
                    touch: Touch.inside,
                    dx: 15.0, // Move 4 pixels to the right.
                    moveByChildWidth:
                        -0.5, // Move half child width to the left.
                    moveByChildHeight: -0.5),
/**/ */
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: 0,
                        height: 15.0,
                      ),
                    ),
                    Container(
                      height: 100.0,
                      child:
                          Image(image: AssetImage("assets/images/directo.png")),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '', //global.appName,
                  style: TextStyle(
                    color: MyColors.sapphire,
                    fontSize: TamanioTexto.logo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 45.0,
                ),
                Text(
                  '\$ 0,99 / mes',
                  style: TextStyle(
                    color: MyColors.sapphire,
                    fontSize: TamanioTexto.logo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Text(
                    'Emite alertas libremente y se partícipe de todo lo que vamos a hacer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: MyColors.grey60,
                        fontSize: TamanioTexto.subtitulo),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
        !Contenedor.periodoGraciaActivo
            ? SizedBox(
                height: 0.0,
              )
            : Align(
                alignment: Alignment.bottomCenter,
                child: Builder(
                  builder: (context) => Center(
                    child: Container(
                      width: Posiciones.getBottomButtonSize(context),
                      height: 50.0,
                      child: FlatButton(
                        color: MyColors.white,
                        onPressed: () {
                          //Inicia el proceso de suscripcion
                          //_requestSubscription(global.suscriptionName);
                          _setMoreTimeToSuscription();
//                    _suscribe(context);
                        },
                        child: Text(
                          'DAME MAS TIEMPO',
                          style: TextStyle(
                              letterSpacing: 1.5, color: MyColors.sapphire),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(22.0),
                          side: BorderSide(color: MyColors.lavender_blue),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        SizedBox(
          height: Posiciones.separacion_inferior_boton,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Builder(
            builder: (context) => Center(
              child: Container(
                width: Posiciones.getBottomButtonSize(context),
                height: 50.0,
                child: FlatButton(
                  color: MyColors.sapphire,
                  onPressed: () {
                    //Inicia el proceso de suscripcion
                    _requestSubscription(global.suscriptionName);

//                    _suscribe(context);
                  },
                  child: Text(
                    'SUSCRIBIRME',
                    style: TextStyle(letterSpacing: 1.5, color: MyColors.white),
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
        )
      ],
    );
  }

/*ES DE VITAL IMPORTANCIA VIGILAR ESTE METODO YA QUE ES EL PRIMERO QUE INICIA
PARA EL TEMA DE LA SUSCRIPCION, POR LO TANTO SI ESTE FALLA EL CLIENTE NO SE PODRA SUSCRIBIR
ADICIONAL A ESTO SI EL CLIENTE NO SE SUSCRIBE, SE SUPONE QUE NO PUEDE USAR LA APP
PERO ESTO SERIA INJUSTO YA QUE EL PROBLEMA ES DE LA APP. PARA ESTO ES NECESARIO
QUE SE CAPTURE EL ERROR Y SE LE PERMITA CONTINUAR USANDO NORMALMENTE LA APP SIN QUE 
NECESITE TERMINAR EL REGISTRO, DESPUES DE UN TIEMPO VOLVER A SUGERIRLE QUE SE SUSCRIBA*/
  _initInappPurchase(context) async {
    try {
      await FlutterInappPurchase.instance.initConnection;
      //print("---------- Connect Billing Button Pressed");
      _getSuscription();
      //print("Se obtubo las suscripciones");
      _getProduct();
      //print("Se obtubo productos");
      setState(() {
        //purchace_ready = true;
      });
    } catch (e) {
      //Error
    }
  }

  Future _getProduct() async {
    try {
      List<IAPItem> items =
          await FlutterInappPurchase.instance.getProducts(_productLists);
      /*for (var item in items) {
        print('${item.toString()}');
        this._itemsProducts.add(item);
      }*/

      setState(() {
        this._itemsProducts = items;
        //this._purchases = [];
      });
    } catch (err) {}
  }

  Future _getSuscription() async {
    try {
      List<IAPItem> items = await FlutterInappPurchase.instance
          .getSubscriptions(_suscriptionLists);
      setState(() {
        this._itemsSuscription = items;
        //this._purchases = [];
      });
    } catch (err) {}
    /*  for (var item in items) {
      //print('${item.toString()}');
      this._items.add(item);
    }*/
  }

  //void _requestSubscription(IAPItem item) {
  void _requestSubscription(String productId) async {
    try {
      global.mostraPantallaSuscripcion = false;
      await FlutterInappPurchase.instance
          .requestSubscription(global.suscriptionName);
    } catch (err) {}
  }

  _setMoreTimeToSuscription() async {
    try {
      global.mostraPantallaSuscripcion = false;
      localDb.save(Dato.estadoCaducado, 'False');
      localDb.save(Dato.periodoGraciaActivo, 'False');
      await _mostrarPopUp(context, false);
    } catch (err) {
      int i = 0;
    }
    //verificar si se lanza main
  }
/*
  Future _getPurchasesSuscription() async {
    String productId = "";
    List<PurchasedItem> items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    if (items.length > 0) {
      productId = items[0].productId;
      if (productId == global.suscriptionName) {
        global.isSuscribed = true;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SuscriptionTankyou()));
      }
    }
    {
      global.isSuscribed = false;
    }
  }*/
/*
  _suscribe(context) async {
/*
    pr = Methods.getPopUp(context);
    await pr.show();
    
      if (myController.text.length > 0) {
        var userQuery = db
            .collection(Coleccion.registro_garita)
            .where(Campos.cod_garita, isEqualTo: myController.text)
            .limit(1);

        userQuery.getDocuments().then((garita) {
          if (garita.documents.length > 0) {
            DocumentSnapshot garitaSnap = garita.documents[0];
            String documentIdGarita = garitaSnap.documentID;

            int generador = garitaSnap[Campos.generador_residente] != null
                ? int.parse(garitaSnap[Campos.generador_residente].toString())
                : 0;

            if (generador != 0) {
              _guardarDb(Coleccion.registro_garita, Campos.generador_residente,
                  (generador + 1).toString(), documentIdGarita);

              Residente residente = new Residente();
              residente.codGarita = garitaSnap['cod_garita'];
              residente.codResidente = generador.toString();
              residente.documentIdGarita = documentIdGarita;
              global.residente = residente;

              pr.hide();
              _continuar(context);
            } else {
              pr.hide();
              _showMessage(
                  'Error generando registro, por favor vuela a intentarlo.',
                  context);
            }
          } else {
            pr.hide();
            _showMessage('El código no existe.', context);
          }
        });
      } else {
        pr.hide();
        _showMessage('El campo esta vacio.', context);
      }
    } catch (e) {
      pr.hide();
    }*/
  }*/
/*
  _guardarDb(
      String collection, String field, String value, String documentId) async {
    await db
        .collection(collection)
        .document(documentId)
        .updateData({field: value});
  }*/
/*
  _showMessage(String _mensaje, context) {
    setState(() {
      global.mensaje = _mensaje;
    });
    return Methods.getMessage(_mensaje, context);
  }*/

  _continuar(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuscriptionTankyou()),
    );
  }

  _mostrarPopUp(context, estadoEnvio) {
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
      titleStyle: TextStyle(
        color: MyColors.sapphire,
      ),
    );
    return Alert(
      style: alertStyle,
      context: context,
      //type: AlertType.success,
      title: "Excelente! puedes seguir usando Alert durante 3 dias.",
      buttons: [
        /*  DialogButton(
          child: Text(
            (estadoEnvio) ? "Inicio" : "Reintentar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          color: (estadoEnvio) ? MyColors.sapphire : Colors.red,
        ),*/
        DialogButton(
            child: Text(
              "Listo",
              style: TextStyle(color: MyColors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainHome()));
            },
            color: MyColors.sapphire)
      ],
    ).show();
  }

  _guardarSuscripcionActiva() async {
    try {
      localDb.save(Dato.suscripcionActiva, "True");
      print('Se guardo suscripcion activa');
    } catch (ex) {
      print('ERROR _guardarSuscripcionActiva ' + ex.toString());
    }
  }
}
