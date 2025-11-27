import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('returns correct name for each type', () {
      expect(
        Sandwich(
                type: SandwichType.veggieDelight,
                isFootlong: true,
                breadType: BreadType.white)
            .name,
        'Veggie Delight',
      );
      expect(
        Sandwich(
                type: SandwichType.chickenTeriyaki,
                isFootlong: false,
                breadType: BreadType.wheat)
            .name,
        'Chicken Teriyaki',
      );
      expect(
        Sandwich(
                type: SandwichType.tunaMelt,
                isFootlong: true,
                breadType: BreadType.wholemeal)
            .name,
        'Tuna Melt',
      );
      expect(
        Sandwich(
                type: SandwichType.meatballMarinara,
                isFootlong: false,
                breadType: BreadType.white)
            .name,
        'Meatball Marinara',
      );
    });

    test('returns correct image path for footlong and six-inch', () {
      final footlong = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sixInch = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.white,
      );
      expect(footlong.image, 'assets/images/tunaMelt_footlong.png');
      expect(sixInch.image, 'assets/images/tunaMelt_six_inch.png');
    });
  });
}
