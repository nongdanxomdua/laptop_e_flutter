import 'package:elaptop/models/cart.dart';
import 'package:elaptop/models/product.dart';
import 'package:elaptop/provider/cartProvider.dart';
import 'package:elaptop/screens/detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MySingleHistoryProduct extends StatelessWidget {
  // const SingleCartProduct({Key? key}) : super(key: key);
  CartModel cart;
  bool? isInCartScreen;
  MySingleHistoryProduct({required this.cart, this.isInCartScreen = true});

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider = Provider.of<CartProvider>(context);
    double amount = 0;
    amount = cart.quantity!;
    //get product by id
    List<Product> _product = Provider.of<List<Product>>(context, listen: true)
        .where((element) => element.id == cart.idProduct)
        .toList();
    return Container(
      height: 140,
      width: double.infinity,
      child: Card(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.fade,
                    alignment: Alignment.bottomCenter,
                    child: Detail(_product[0]),
                  ));
                },
                child: Container(
                  height: 130,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage('${_product[0].image}'),
                    ),
                  ),
                ),
              ),
              Container(
                height: 130,
                width: 230,
                child: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 160,
                              child: Text(
                                _product[0].title,
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              width: 30,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  cartProvider.deleteProductCart(cart.id!);
                                  // .completeBuyProductCart(cart.id!);
                                  // print('LOGGER: ${cart.id!}');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        // '${price}₫',
                        NumberFormat.currency(
                                locale: 'vi', symbol: 'đ', decimalDigits: 0)
                            .format(_product[0].price),
                        style: TextStyle(
                          color: Color(0xff9b96d6),
                          fontFamily: 'Lato',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 35,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: Color(0xfff2f2f2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        'Quantity: ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Lato',
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        amount.toInt().toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  child: IconButton(
                                    icon: Icon(Icons.restore_rounded),
                                    onPressed: () {
                                      cartProvider.reBuyProductCart(cart.id!);
                                      // .completeBuyProductCart(cart.id!);
                                      // print('LOGGER: ${cart.id!}');
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
