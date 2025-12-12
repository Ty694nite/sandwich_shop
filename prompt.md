You are an expert Flutter engineer helping me extend a small sandwich shop app.

## Existing app

The app is written in Flutter and currently has:

- **Screens**
  - **Order screen**
    - Users select a sandwich:
      - `Sandwich` has: `type`, `size` (or `isFootlong`), and `breadType`
    - Users choose quantity and add sandwiches to a **Cart**
  - **Cart screen**
    - Users see:
      - A list of sandwiches in the cart
      - The quantity for each sandwich
      - The total cart price

- **Models**
  - **Sandwich**
    - Fields: `type`, `size` (or `isFootlong`), `breadType`
  - **Cart**
    - Internally stores sandwiches and their quantities
    - Methods (or equivalent):
      - `add(Sandwich sandwich, {int quantity = 1})`
      - `remove(Sandwich sandwich, {int quantity = 1})`
      - `clear()`
      - `double get totalPrice`
      - Helpers like `countOfItems`, `length`, etc.
- **Repository**
  - **PricingRepository**
    - `double calculatePrice({required int quantity, required bool isFootlong})`
    - Price depends **only on quantity and size**, not on sandwich type or bread type

Assume normal Flutter app structure with `OrderScreen` and `CartScreen` widgets, and that navigation between them already works.

---

## New feature: Modify items in the cart

I want to let users **modify items in their cart** from the **Cart screen**. Below are the features I want, with clear behavior descriptions. Please design and implement them in a way that integrates cleanly with the existing models and the `PricingRepository`.

### 1. Change quantity of a cart item

**Description**

On the Cart screen, for each sandwich in the cart, the user should be able to change the quantity using simple controls (e.g., `+` and `–` buttons, or a stepper-like UI).

**User actions and expected behavior**

- **Tap “+” (increase quantity) on a cart line item**
  - The quantity for that sandwich in the `Cart` is incremented by 1.
  - The `Cart` internal data structure is updated.
  - The line item subtotal (for that sandwich) is recalculated using `PricingRepository.calculatePrice`.
  - The cart’s `totalPrice` is updated and the UI reflects the new total.
  - The change should be wrapped in `setState` (or an appropriate state-management update) so the UI refreshes immediately.
- **Tap “–” (decrease quantity) on a cart line item**
  - If the current quantity is greater than 1:
    - Decrease the quantity by 1.
    - Recalculate that line item’s price using `PricingRepository`.
    - Recalculate the cart `totalPrice` and update the UI.
  - If the quantity would go from 1 → 0:
    - Either:
      - Remove the item entirely from the cart **or**
      - Ask for confirmation (e.g., a dialog: “Remove this item from cart?”) and then remove it.
    - After removal, the cart list and `totalPrice` are updated and re-rendered.

**Implementation guidance**

- Reuse the existing `Cart` model methods where possible:
  - Prefer `cart.add(sandwich, quantity: 1)` for increment
  - Prefer `cart.remove(sandwich, quantity: 1)` for decrement
- Do **not** bypass `PricingRepository`; always use it to calculate prices so pricing logic stays centralized.
- Keep the UI implementation simple (e.g., a `Row` with:
  - `IconButton(Icons.remove)`
  - `Text(currentQuantity.toString())`
  - `IconButton(Icons.add)`).

---

### 2. Remove a line item entirely

**Description**

From the Cart screen, the user should be able to remove an entire sandwich entry from the cart in a single action (e.g., a “Remove” button or a swipe-to-delete gesture).

**User actions and expected behavior**

- **Tap a “Remove” button on a cart item**
  - All quantities of that sandwich are removed from the cart.
  - The `Cart` no longer contains that `Sandwich` key.
  - The cart list UI no longer shows that item.
  - The `totalPrice` is recalculated and updated on screen.
- **(Optional) Swipe-to-delete on a cart item**
  - When the user swipes a cart item (e.g., using `Dismissible`), the item is removed from the `Cart`.
  - Show a transient confirmation such as a `SnackBar`:
    - Text: “Removed [sandwich description] from cart”
    - Optional: an “UNDO” action that re-adds the removed item and quantity.

**Implementation guidance**

- Prefer adding a dedicated method to `Cart` if needed, like `removeCompletely(Sandwich sandwich)`, or use repeated calls to `remove` until the item is gone.
- Integrate nicely with Flutter’s `ListView` and possibly `Dismissible` for swipe-to-delete.
- Ensure that any removal triggers UI update via state management.

---

### 3. Clear the entire cart

**Description**

Provide a simple way to clear all items from the cart at once (e.g., a “Clear Cart” button at the top or bottom of the Cart screen).

**User actions and expected behavior**

- **Tap “Clear Cart” button**
  - Show a confirmation prompt (dialog or bottom sheet), e.g., “Are you sure you want to remove all items from your cart?”
  - If the user confirms:
    - Call `cart.clear()`.
    - The cart items list becomes empty in the UI.
    - The `totalPrice` becomes `0.00` in the UI.
  - If the user cancels:
    - No change to the cart; the UI remains the same.

**Implementation guidance**

- Use the existing `Cart.clear()` method.
- Keep the UI for this action simple, like a `TextButton` or `IconButton` in the app bar or at the bottom of the Cart screen.

---

### 4. Keep the order screen and cart screen in sync

**Description**

When a user modifies quantities or removes items in the Cart screen, these changes should be reflected throughout the app, including the Order screen’s permanent cart summary (item count and total price).

**User actions and expected behavior**

- **User changes quantity or removes an item on the Cart screen**
  - The shared `Cart` instance is updated.
  - The permanent cart summary (e.g., a `Container` or `Card` on the Order screen showing:
    - number of items
    - total price
    ) automatically reflects the updated `Cart` state once the user navigates back or if they are both visible.
- **User clears the cart on the Cart screen**
  - The permanent summary on the Order screen should show:
    - 0 items
    - a total price of \$0.00.

**Implementation guidance**

- Explain a simple, idiomatic way to share the `Cart` instance between the Order screen and Cart screen, such as:
  - Passing the same `Cart` object through constructors, or
  - Using an inherited widget / provider-like state management (if appropriate), but keep it as lightweight as possible.
- Avoid duplicating pricing logic; always lean on `PricingRepository`.

---

## What I want from you

1. Propose a clean, idiomatic Flutter design (no heavy frameworks) to:
   - Add quantity controls (`+` / `–`) in the Cart screen
   - Add a “Remove item” action for each cart line
   - Add a “Clear Cart” action
   - Keep the Order and Cart screens in sync via the `Cart` model

2. Provide concrete code examples:
   - UI code for the Cart screen list item showing:
     - sandwich details
     - quantity controls
     - per-item total
     - remove action
   - Updates to the `Cart` model if needed (e.g., helper methods)
   - Any simple state-management or navigation wiring necessary

3. Make sure to:
   - Use the existing `Cart` and `Sandwich` models
   - Use `PricingRepository` to compute prices for line items and totals
   - Keep the implementation as simple and understandable as possible