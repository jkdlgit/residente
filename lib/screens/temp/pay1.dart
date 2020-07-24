import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

final String testID = 'gems_test';

void main() {
  ///Include this in main() so purchases are enabled
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(new MarketScreen());
}

class MarketScreen extends StatefulWidget {
  createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription _subscription;

  /// Consumable credits the user can buy
  int credits = 0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Initialize data
  void _initialize() async {
    // Check availability of In App Purchases

    _iap = InAppPurchaseConnection.instance;
    available = await _iap.isAvailable();

    if (available) {
      await _getProducts();
      await _getPastPurchases();

      // Verify and deliver a purchase with your own business logic
      _verifyPurchase();
    }

    // Listen to new purchases
    _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
          print('NEW PURCHASE');
          _purchases.addAll(data);
          _verifyPurchase();
        }));
  }

  /// Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from([
      'lapiz',
      'mouse',
      'pelota',
      'android.test.purchased',
      'android.test.canceled'
    ]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  /// Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  /// Your own business logic to setup a consumable
  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased(testID);

    // TODO serverside verification & record consumable in the database

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      credits = 10;
    }
  }

  /// Purchase a product
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  /// Spend credits and consume purchase when they run pit
  void _spendCredits(PurchaseDetails purchase) async {
    /// Decrement credits
    setState(() {
      credits--;
    });

    /// TODO update the state of the consumable to a backend database

    // Mark consumed when credits run out
    if (credits == 0) {
      var res = await _iap.consumePurchase(purchase);
      await _getPastPurchases();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      home: Scaffold(
        appBar: AppBar(
          title: Text(available ? 'Open for Business' : 'Not Available'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // UI if already purchased

              Text('💎 $credits', style: TextStyle(fontSize: 60)),

              FlatButton(
                child: Text('Consume'),
                color: Colors.green,
                onPressed: () => _spendCredits(_hasPurchased(_products[0].id)),
              ),

              // UI if NOT purchased

              Text(_products[0].title,
                  style: Theme.of(context).textTheme.headline),
              Text(_products[0].description),
              Text(_products[0].price,
                  style: TextStyle(color: Colors.greenAccent, fontSize: 60)),
              FlatButton(
                child: Text('Buy It'),
                color: Colors.green,
                onPressed: () => _buyProduct(_products[0]),
              ),

/*

              for (var p in _products)   
                   
                  // UI if already purchased
                  if (_hasPurchased(p.id) != null)
                    
                      Text('💎 $credits', style: TextStyle(fontSize: 60)),
                      
                      FlatButton(
                        child: Text('Consume'),
                        color: Colors.green,
                        onPressed: ()=>
                          _spendCredits(_hasPurchased("hola")),
                      ),
                        
                    
                    
              
                  // UI if NOT purchased
                  else
                    
                      Text(prod.title,
                          style: Theme.of(context).textTheme.headline),
                      Text(prod.description),
                      Text(prod.price,
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 60)),
                      FlatButton(
                        child: Text('Buy It'),
                        color: Colors.green,
                        onPressed: () => _buyProduct(prod),
                      ),
                    
                }*/
            ],
          ),
        ),
      ),
    );
  }
}
