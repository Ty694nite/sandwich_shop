class PricingRepository {
  double calculateTotalPrice(
      {required int quantity, required bool isFootlong}) {
    final double pricePerSandwich = isFootlong ? 11.0 : 7.0; // Updated prices
    return quantity * pricePerSandwich; // Calculate total price
  }
}
