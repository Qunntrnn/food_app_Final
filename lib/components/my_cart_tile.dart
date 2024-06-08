import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_quantity_selector.dart';
import 'package:flutter_application_1/models/cart_item.dart';
import 'package:flutter_application_1/models/restaurant.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  const MyCartTile({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // food image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      cartItem.food.imagePath,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // name and price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cartItem.food.name),
                        Text(
                          '\$' + cartItem.food.price.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: QuantitySelector(
                      food: cartItem.food,
                      onDecrement: () {
                        restaurant.removeFromCart(cartItem);
                      },
                      onIncrement: () {
                        restaurant.addToCart(
                            cartItem.food, cartItem.selectedAddons);
                      },
                      quantity: cartItem.quantity,
                    ),
                  ),
                ],
              ),
            ),
            // addons
            SizedBox(
              height: cartItem.selectedAddons.isEmpty ? 0 : 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: Row(
                  children: cartItem.selectedAddons.map((addon) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Row(
                          children: [
                            // addon name
                            Text(addon.name),
                            // addon price
                            Text(' (\$${addon.price})'),
                          ],
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onSelected: (value) {},
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
