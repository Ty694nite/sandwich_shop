import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'sandwich.dart';

class CartItem {
  final Sandwich sandwich;
  int quantity;
  String? note;

  CartItem({
    required this.sandwich,
    this.quantity = 1,
    this.note,
  });
}

class Cart {
  final List<CartItem> items = [];
  final PricingRepository pricingRepository = PricingRepository();
  double discount = 0.0;
  String? promoCode;
  final double restaurantMinimumOrder;

  Cart({
    this.restaurantMinimumOrder = 0.0,
  });

  // Add item to cart
  void addItem(CartItem item) {
    items.add(item);
  }

  // Remove item from cart
  void removeItem(CartItem item) {
    items.remove(item);
  }

  // Update quantity for an item
  void updateQuantity(CartItem item, int quantity) {
    item.quantity = quantity;
  }

  // Edit customization note for an item
  void editNote(CartItem item, String note) {
    item.note = note;
  }

  // Customization summary
  List<String> customizationSummary() {
    return items.map((item) {
      return '${item.sandwich.name}: ${item.note ?? "No notes"}';
    }).toList();
  }

  // Calculate total price before discount
  double totalPrice() {
    double total = 0.0;
    for (var item in items) {
      total += pricingRepository.calculatePrice(
        quantity: item.quantity,
        isFootlong: item.sandwich.isFootlong,
      );
    }
    return total;
  }

  // Apply promo code and calculate discount
  void applyPromoCode(String code) {
    promoCode = code;
    // Example: flat £5 discount for code "SAVE5"
    if (code == "SAVE5") {
      discount = 5.0;
    } else {
      discount = 0.0;
    }
  }

  // Get price after discount
  double finalPrice() {
    return (totalPrice() - discount).clamp(0.0, double.infinity);
  }

  // Check if minimum order met
  bool isMinimumOrderMet() {
    return finalPrice() >= restaurantMinimumOrder;
  }

  // Price breakdown
  Map<String, double> priceBreakdown() {
    return {
      'Subtotal': totalPrice(),
      'Discount': discount,
      'Total': finalPrice(),
    };
  }
}
