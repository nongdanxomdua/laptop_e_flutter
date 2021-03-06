import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elaptop/models/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CartProvider with ChangeNotifier {
  //get user id
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid;

  Future<String> getUidAuth() async {
    String userId = await auth.currentUser!.uid.toString();
    uid = userId;
    return userId;
  }

  String get getUserId {
    return uid!;
  }
  //

//cart
  CartModel? cartProduct;
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');
  //add product to cart
  Future<void> addProductToCart(
      String idProduct, double quantity, String currentUser) async {
    final docRef = FirebaseFirestore.instance.collection('cart').doc();
    getUidAuth();
    print('logger2: ${docRef.id}');
    await docRef.set({
      'idProduct': idProduct,
      'quantity': quantity,
      'user': currentUser,
      // 'user': 'demouserid',
      'id': docRef.id.toString(),
      'isBuy': false
    });
  }

  //update product to cart
  Future<void> updateProductCart(String id, double quantity) async {
    await cartCollection.doc(id).update({'quantity': quantity});
  }

  Future<void> addProductCartIsExistInCart(
      String idProduct, double quantity, String currentUser) async {
    List<CartModel> newListCart = [];
    // getUserId;
    CartModel temp;
    QuerySnapshot cartSnapShot = await FirebaseFirestore.instance
        .collection("cart")
        .where('user', isEqualTo: currentUser)
        .get();
    cartSnapShot.docs.forEach((element) {
      temp = CartModel(
          id: element['id'],
          idUser: element['user'],
          idProduct: element['idProduct'],
          quantity: element['quantity'].toDouble(),
          isBuy: false);
      newListCart.add(temp);
    });

    List<CartModel> newCart =
        newListCart.where((item) => item.idProduct == idProduct).toList();

    await cartCollection
        .doc(newCart[0].id)
        .update({'quantity': quantity + (newCart[0].quantity!.toDouble())});

    // print('LOGGER_USERID: ${getUserId} \n LOGGER_LIST_CART: ${newCart[0].id}');
  }

  //delete product to cart
  Future<void> deleteProductCart(String id) async {
    // getUidAuth();
    await cartCollection.doc(id).delete();
  }

  //complete buy
  Future<void> completeBuyProductCart(String id) async {
    DateTime now = new DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('kk:mm:ss').format(now);
    // getUidAuth();
    // getUserId;
    await cartCollection.doc(id).update(
        {'dateBuy': formattedDate, 'timeBuy': formattedTime, 'isBuy': true});
  }

  //buy again
  Future<void> reBuyProductCart(String id) async {
    await cartCollection.doc(id).update({'isBuy': false});
  }

  //buy again if existing in cart
  //check product is in cart
  Future<void> reBuyProductExistingInCart(String idProduct, String currentUser,
      double quantity, String cartId) async {
    CartModel temp;
    List<CartModel> newListCart = [];
    QuerySnapshot cartSnapShot = await FirebaseFirestore.instance
        .collection("cart")
        .where('user', isEqualTo: currentUser)
        .where('isBuy', isEqualTo: false)
        .get();
    cartSnapShot.docs.forEach((element) {
      temp = CartModel(
          id: element['id'],
          idUser: element['user'],
          idProduct: element['idProduct'],
          quantity: element['quantity'].toDouble(),
          isBuy: element['isBuy']);
      newListCart.add(temp);
    });

    List<CartModel> newCart =
        newListCart.where((item) => item.idProduct == idProduct).toList();

    if (newCart.length > 0) {
      //update quantity of product in cart
      await cartCollection.doc(newCart[0].id).update({
        'quantity': quantity + (newCart[0].quantity!.toDouble()),
      });
      await deleteProductCart(cartId);
    } else {
      //update isBuy false -> true
      await reBuyProductCart(cartId);
    }

    // print('loggger idProduct in CartProvider: ${idProduct}');
    // print('loggger currentUser in CartProvider: ${currentUser}');
    // print('loggger quantity in CartProvider: ${quantity}');
    // print('loggger in CartProvider:; ${newCart.length}');

    // await cartCollection
    //     .doc(newCart[0].id)
    //     .update({'quantity': quantity + (newCart[0].quantity!.toDouble())});
  }
}
