import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/food.dart';
import 'package:flutter_application_1/models/cart_item.dart';
import 'package:intl/intl.dart';

class Restaurant extends ChangeNotifier {
  //List of food menu
  final List<Food> _menu = [
    //burgers
    Food(
        name: "Classic Cheeseburger",
        description: "Một chiếc burger với thịt bò,đẫm phô mai và các loại rau",
        imagePath: "lib/images/burgers/cheese_burger.png",
        price: 0.99,
        category: FoodCategory.burgers,
        availableAddons: [
          Addon(name: "Extra cheese", price: 0.99),
          Addon(name: "Bacon", price: 0.99),
          Addon(name: "Avocado", price: 0.99)
        ]),
    //salads
    Food(
        name: "Vegetable salad",
        description:
            "Salad rau củ với cà chua , rau cải, ớt chuông cùng các loại gia vị và sốt mayonaise",
        imagePath: "lib/images/salads/veget_salad.png",
        price: 0.99,
        category: FoodCategory.salads,
        availableAddons: [
          Addon(name: "Extra sauce", price: 0.99),
        ]),
    //sides
    Food(
        name: "Potato fries",
        description: "Khoai tây chiên giòn rụm cùng với muối",
        imagePath: "lib/images/sides/potato_fries.png",
        price: 0.99,
        category: FoodCategory.sides,
        availableAddons: [
          Addon(name: "Cheese powder", price: 0.99),
          Addon(name: "Spicy powder", price: 0.99),
        ]),
    //desserts
    Food(
        name: "Chocolate cupcake",
        description: "Bánh ngọt vị chocolate",
        imagePath: "lib/images/desserts/cupcake.png",
        price: 0.99,
        category: FoodCategory.desserts,
        availableAddons: [
          Addon(name: "More chocolate", price: 0.99),
          Addon(name: "Vanila cream", price: 0.99),
        ]),
    //drinks
    Food(
        name: "Milk Tea",
        description: "Trà sữa",
        imagePath: "lib/images/drinks/milktea.png",
        price: 0.99,
        category: FoodCategory.drink,
        availableAddons: [
          Addon(name: "More sugar", price: 0.99),
          Addon(name: "More topping", price: 0.99),
          Addon(name: "More ice", price: 0.99),
        ]),
  ];

  //user cart
  final List<CartItem> _cart = [];
  //delivery address
  String _deliveryAddress = 'Thai Binh city';
  /*
  
  G E T T E R S

   */

  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  String get deliveryAddress => _deliveryAddress;

  /*
  
  O P E R A T I O N S

   */

  // add to cart
  void addToCart(Food food, List<Addon> selectedAddons) {
    // see if there is a cart item already with the same food and selected addon
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      //check if the food items are the same
      bool isSameFood = item.food == food;

      //check if the list of the selected addons are the same
      bool isSameAddons =
          ListEquality().equals(item.selectedAddons, selectedAddons);

      return isSameFood && isSameAddons;
    });

    //if item  already exists, increase it's quantity
    if (cartItem != null) {
      cartItem.quantity++;
    }

    // otherwise, add a new cart item to the cart
    else {
      _cart.add(
        CartItem(
          food: food,
          selectedAddons: selectedAddons,
        ),
      );
    }
    notifyListeners();
  }

  //remove from cart
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  //get total price of cart
  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  //get total number of items
  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  //clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  //update delivery address
  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  /*
  
  H E L P E R S

   */

  //generate a receipt
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here is your receipt");
    receipt.writeln();

    //format the date to include up to seconds only
    String formattedDate =
        DateFormat('yyyy-MM-dd HH-mm-ss').format(DateTime.now());
    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("---------");

    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt
            .writeln("    Add ons:${_formatAddons(cartItem.selectedAddons)}");
      }
      receipt.writeln();
    }
    receipt.writeln("---------");
    receipt.writeln("");
    receipt.writeln("Total Items:${getTotalItemCount()}");
    receipt.writeln("Total Price:${_formatPrice(getTotalPrice())}");

    return receipt.toString();
  }

  //format double value into money
  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

  //format list of addons into a string summary
  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name}(${_formatPrice(addon.price)})")
        .join(",");
  }
}
