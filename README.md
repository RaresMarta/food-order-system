# Food Order System

A Ruby on Rails web app for browsing, managing, and ordering food items. The system supports user authentication, a shopping cart, and an admin dashboard for managing menu items.

---

## Features

- **User Authentication:** Register, log in, and log out securely.
- **Food Menu:** Browse food items with categories, prices, and images.
- **Shopping Cart:** Add, update, and remove items from your cart.
- **Admin Dashboard:** Create, update, and delete food items (with image upload).
- **Authorization:** Only logged-in users can manage their cart.
- **Responsive UI:** Clean, user-friendly interface.

---

## Project Structure

- `app/controllers`: Rails controllers (e.g., `food_items_controller.rb`, `cart_items_controller.rb`)
- `app/models`: ActiveRecord models (`User`, `FoodItem`, `CartItem`, etc.)
- `app/services`: Business logic (e.g., `cart_service.rb`, `food_item_service.rb`)
- `app/views`: HAML templates for UI
- `config/routes.rb`: Application routes

---

## Key Endpoints

| Path                | Method   | Purpose                        |
|---------------------|----------|--------------------------------|
| `/`                 | GET      | Food menu (home)               |
| `/register`         | GET/POST | User registration              |
| `/login`            | GET/POST | User login                     |
| `/logout`           | DELETE   | User logout                    |
| `/cart`             | GET      | View cart                      |
| `/cart_items`       | POST     | Add item to cart               |
| `/cart_items/:id`   | PATCH    | Update cart item quantity      |
| `/cart_items/:id`   | DELETE   | Remove item from cart          |
| `/dashboard`        | GET      | Admin dashboard (food items)   |
| `/food_items`       | POST     | Create food item (admin)       |
| `/food_items/:id`   | PATCH    | Update food item (admin)       |
| `/food_items/:id`   | DELETE   | Delete food item (admin)       |

---

## Getting Started

### Prerequisites

- Ruby (see `.ruby-version`)
- Rails 7+
- PostgreSQL

### Setup

1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-org/food-order-system.git
   cd food-order-system
   ```

2. **Install dependencies:**
   ```sh
   bundle install
   ```

3. **Database setup:**
   ```sh
   rails db:create db:migrate db:seed
   ```

4. **Run the server:**
   ```sh
   rails server
   ```

5. **Access the app:**
   Visit [http://localhost:3000](http://localhost:3000)

---

## Running Tests

```sh
bundle exec rspec
```

---

## Docker Support

Build and run with Docker:

```sh
docker compose up --
