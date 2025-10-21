# App Screens Overview

This project is built using **SwiftUI** and **UIKit**, following the **MVVM** architecture.  
It also uses **Combine** for reactive programming.  
Minimum iOS version: **iOS 16**.

---

## Catalog
- Displays a list of 15–20 products with name, description, and price.
- Includes a search bar for filtering products.
- Tapping on a product opens a detailed product page.
- Product detail screen contains buttons:
  - **Add to Favorites**
  - **Add to Cart**

## Favorites
- Displays a list of products added to favorites.
- Ability to remove a product from favorites.
- Includes a search bar to search within favorites.
- If the list is empty, shows a message: *"Currently empty."*

## Cart
- Displays a list of products added to the cart with quantity control.
- Quantity can be increased or decreased.
- If quantity reaches zero, the product is removed from the cart.
- Displays the total price of all items.
- Includes a button **"Clear Cart"**.

## Mini Browser (Google)
- Button to open an in-app browser.
- Opens the Google homepage.
- Bottom navigation includes buttons:
  - **Back**
  - **Forward**
  - **Refresh**
  - **Close**
- Shows a loading indicator during page load.
- If the page fails to load, displays a message *"Failed to load"* and a **"Try Again"** button.

## Settings
- Theme switcher: **Light / Dark / System**.
- The selected theme is applied throughout the app and saved for future sessions.

---

## Project Details
- **Languages & Frameworks:** Swift, SwiftUI, UIKit, Combine  
- **Architecture:** MVVM  
- **Minimum iOS Version:** 16.0  
- **Author / Maintainer:** [Isudoxan]

---

## Future Improvements / To-Do
1. Disable ‹ › buttons in web controller immediately when clicked, not only after page load.  
2. Disable ‹ › buttons when an error page is displayed.    
3. Add web-view site title to the navigation bar.  
4. In `SettingsManager`, merge `AppTheme` and `ColorScheme` enums to avoid duplication (use an extension).  
