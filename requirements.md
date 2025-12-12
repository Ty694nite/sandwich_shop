## Feature: Cart Item Modification for Sandwich Shop App

---

### 1. Feature Description and Purpose

#### 1.1 Overview

The Sandwich Shop app currently allows users to:

- Select sandwiches on the **Order Screen** (type, size, bread type, quantity).
- Add selected sandwiches to a **Cart**.
- View items in the **Cart Screen** along with the **total price**.

The new feature extends the Cart Screen to allow users to **modify existing items in their cart**. This includes:

1. Changing the **quantity** of each cart item.
2. **Removing** individual items from the cart.
3. **Clearing the entire cart**.
4. Keeping the **Order Screen’s permanent cart summary** in sync with the cart modifications.

The app already has:

- **`Sandwich` model**
  - Fields: `type`, `size` (or `isFootlong`), `breadType`.
- **`Cart` model**
  - Internal map: `Map<Sandwich, int>` (sandwich → quantity).
  - Core methods: `add`, `remove`, `clear`, `totalPrice`, `isEmpty`, `length`, `countOfItems`, etc.
- **`PricingRepository`**
  - `double calculatePrice({required int quantity, required bool isFootlong})`
  - Price depends only on **quantity** and **size** (footlong vs six-inch); not on type or bread.

#### 1.2 Purpose

The purpose of this feature is to:

- Give users **fine-grained control** over their cart without having to re-add sandwiches from scratch.
- Improve **usability and flexibility**, making it easy to:
  - Fix mistakes (e.g., wrong quantity).
  - Remove unwanted items.
  - Quickly empty the cart before starting a new order.
- Ensure that **pricing logic remains centralized** in `PricingRepository`, and **cart state remains consistent** across screens.

---

### 2. User Stories

Each user story is written from the perspective of an end user interacting with the app.

#### 2.1 Change Quantity of a Cart Item

**Story 2.1.1 – Increase quantity of an existing cart item**

> As a user,  
> I want to increase the quantity of a sandwich that is already in my cart,  
> so that I can quickly order more of the same sandwich without going back to the order screen.

**Story 2.1.2 – Decrease quantity of an existing cart item**

> As a user,  
> I want to decrease the quantity of a sandwich in my cart,  
> so that I can correct mistakes or adjust my order before checkout.

**Story 2.1.3 – Prevent negative or invalid quantities**

> As a user,  
> I want the app to prevent invalid quantities (e.g., negative numbers),  
> so that my cart always reflects a valid, real-world order.

---

#### 2.2 Remove a Line Item from the Cart

**Story 2.2.1 – Remove a single sandwich entry**

> As a user,  
> I want to remove a specific sandwich from my cart in one action,  
> so that I can quickly get rid of items I no longer want.

**Story 2.2.2 – Optional undo for accidental removal (if implemented)**

> As a user,  
> I want the option to undo a recent removal,  
> so that I can easily fix accidental deletions without reconfiguring the sandwich from scratch.

---

#### 2.3 Clear the Entire Cart

**Story 2.3.1 – Clear all items**

> As a user,  
> I want to clear my entire cart with a single action,  
> so that I can start a new order from scratch.

**Story 2.3.2 – Confirmation before clearing**

> As a user,  
> I want the app to confirm before clearing the entire cart,  
> so that I don’t accidentally lose my entire order.

---

#### 2.4 Keep Order Screen and Cart Screen in Sync

**Story 2.4.1 – Consistent cart summary on Order Screen**

> As a user,  
> I want the permanent cart summary on the order screen (items count and total price)  
> to always reflect the latest changes I made in the cart,  
> so that I can trust the information shown wherever I am in the app.

**Story 2.4.2 – Shared cart state between screens**

> As a user,  
> I want changes I make on the cart screen (like quantity changes, removals, or clearing)  
> to be preserved when I navigate back to the order screen,  
> so that I never see stale or outdated cart information.

---

### 3. Acceptance Criteria

Each subsection corresponds to a sub-feature. All criteria must be satisfied for the feature to be considered complete.

---

#### 3.1 Change Quantity of a Cart Item

##### UI / Interaction

1. For each cart line item on the Cart Screen, the UI must display:
   - The sandwich description (type, size, bread type).
   - The current quantity.
   - Two controls to adjust quantity:
     - An **increment** control (e.g., `+` button).
     - A **decrement** control (e.g., `–` button).
2. The quantity value must be clearly visible and updated in real time when changed.

##### Behavior: Increment

3. When the user taps the **increment** control for a given line item:
   - The corresponding sandwich quantity in the `Cart` model increases by **exactly 1**.
   - `Cart.add(sandwich, quantity: 1)` (or equivalent) is invoked.
   - The line item’s subtotal is recalculated using `PricingRepository.calculatePrice`.
     - `isFootlong` or size is taken from that item’s `Sandwich`.
   - The cart’s `totalPrice` is recalculated and displayed.
   - The UI updates immediately (same frame after `setState` / state update).

##### Behavior: Decrement

4. When the user taps the **decrement** control for a given line item:
   - If the current quantity is **greater than 1**:
     - The quantity decreases by **exactly 1**.
     - `Cart.remove(sandwich, quantity: 1)` (or equivalent) is invoked.
     - The line item’s subtotal is recalculated using `PricingRepository`.
     - The cart’s `totalPrice` is recalculated and displayed.
     - The UI updates immediately.
   - If the current quantity is **exactly 1**:
     - One of the following behaviors MUST be implemented (and documented in the UI/UX):
       - EITHER the item is removed entirely from the cart (equivalent to “remove item”).
       - OR a confirmation prompt appears:  
         “Remove this item from your cart?” with Yes/No choices.
           - If Yes: remove the item completely.
           - If No: keep quantity at 1; no change occurs.
5. Quantity must **never** drop below 0. Under no user interaction should the cart display a negative quantity.

##### Pricing

6. The calculation of line item prices and total price:
   - MUST use `PricingRepository.calculatePrice` for consistency.
   - MUST NOT hard-code prices or calculate them directly in the UI.
7. Changing quantity must correctly update:
   - The per-item displayed price (if shown).
   - The cart `totalPrice`.

---

#### 3.2 Remove a Line Item Entirely

##### UI / Interaction

1. Each cart line item must have a clear way to be removed, via:
   - A dedicated “Remove” button (e.g., trash icon, “Remove” text button), and/or
   - A swipe-to-delete interaction using `Dismissible`.
2. The affordance for removal (button or swipe) must be discoverable and consistent across all items.

##### Behavior

3. When the user triggers item removal:
   - The corresponding `Sandwich` and its quantity are removed from the `Cart` internal map.
     - The cart no longer contains that sandwich key.
   - Any `Cart` method used (e.g., `removeCompletely(sandwich)` or similar) must:
     - Ensure no leftover quantity or stub entries remain.
4. After removal:
   - That item disappears from the Cart Screen UI list.
   - The cart’s `totalPrice` is recalculated and updated.
   - The total item count / summary (if displayed) is updated.
5. Optional (if undo is implemented):
   - A `SnackBar` or similar transient message appears with:
     - Text like: “Removed [sandwich description] from cart”.
     - An “UNDO” action.
   - If the user taps “UNDO”:
     - The previously removed item and its prior quantity are restored to the cart.
     - The UI and `totalPrice` update accordingly.

---

#### 3.3 Clear the Entire Cart

##### UI / Interaction

1. The Cart Screen must include a **“Clear Cart”** action, implemented as:
   - A `TextButton` or `IconButton` labeled clearly (e.g., “Clear Cart”) in the app bar or at the bottom of the screen.
2. The action must be prominently but not accidentally triggered (e.g., not a small or hidden icon without label).

##### Behavior

3. When the user taps “Clear Cart”:
   - A confirmation dialog or bottom sheet appears, with:
     - A descriptive message (e.g., “Are you sure you want to remove all items from your cart?”).
     - Two options: Confirm (Yes/Clear) and Cancel.
4. If the user **confirms**:
   - `Cart.clear()` is called.
   - The internal map of items becomes empty.
   - The Cart Screen list shows **no items**.
   - The cart’s `totalPrice` becomes `0.0` and is displayed as such (e.g., `$0.00`).
5. If the user **cancels**:
   - `Cart.clear()` is **not** called.
   - The cart contents and UI remain unchanged.

---

#### 3.4 Keep Order Screen and Cart Screen in Sync

##### Shared State

1. The app must use a **single shared `Cart` instance** between the Order Screen and Cart Screen:
   - Either passed via constructors or via a simple shared state mechanism (e.g., inherited widget or provider).
   - No duplicate or independent `Cart` instances that can get out of sync.

##### Behavior on Navigation

2. When the user:
   - Modifies quantities,
   - Removes items,
   - Or clears the cart on the Cart Screen,  
   and then navigates back to the Order Screen:
   - The **Order Screen’s permanent cart summary** must immediately reflect:
     - The correct total number of items (`countOfItems` or similar).
     - The correct total price (`totalPrice` via `PricingRepository`).
3. If the permanent cart summary is visible **while** adding items on the Order Screen:
   - Any call to `Cart.add` there must also update:
     - The total item count displayed.
     - The total price.
4. No stale data:
   - At any point, if the Order Screen shows a cart summary, it must always be derived directly from the shared `Cart` instance.

---

#### 3.5 Technical & Integration Requirements

1. **Use of existing models and repository**
   - The `Sandwich` and `Cart` models must not be replaced; instead, they may be extended with helper methods if needed.
   - All price-related UI values must be computed using `PricingRepository.calculatePrice`.
2. **Code Quality**
   - The solution must avoid duplicating pricing logic in UI widgets.
   - New code should be reasonably commented where behavior might be non-obvious (e.g., confirm dialogs, undo behavior).
3. **Testing (high-level)**
   - There should be widget and/or unit tests verifying that:
     - Increasing quantity updates displayed quantity and total price.
     - Decreasing quantity works correctly and never goes below 0.
     - Removing an item updates the cart and total price.
     - Clearing the cart empties the cart and sets total price to 0.
     - Order Screen summary reflects changes made on