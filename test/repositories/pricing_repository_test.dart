import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    final pricingRepository = PricingRepository();

    test('calculates total price for footlong sandwiches', () {
      final total = pricingRepository.calculateTotalPrice(
        quantity: 2,
        isFootlong: true,
      );
      expect(total, 22.0); // 2 * £11
    });

    test('calculates total price for six-inch sandwiches', () {
      final total = pricingRepository.calculateTotalPrice(
        quantity: 3,
        isFootlong: false,
      );
      expect(total, 21.0); // 3 * £7
    });

    test('calculates total price for zero quantity', () {
      final total = pricingRepository.calculateTotalPrice(
        quantity: 0,
        isFootlong: true,
      );
      expect(total, 0.0);
    });
  });
}
