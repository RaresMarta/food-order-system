module DashboardHelper
  def dashboard_category_options
    [
      [ "Entrees", "entrees" ],
      [ "Main courses", "main-courses" ],
      [ "Second courses", "second-courses" ],
      [ "Salads", "salads" ],
      [ "Pizza", "pizza" ],
      [ "Desserts", "desserts" ]
    ]
  end

  def dashboard_table_headers
    [ "ID", "Name", "Category", "Price", "Vegetarian", "Image", "Actions" ]
  end

  def cards
    [
      { title: "Order Management", text: "View and manage all customer orders.", btn_class: "btn btn-primary", btn_path: dashboard_orders_path, btn_text: "Manage Orders" },
      { title: "Menu Management", text: "Add, edit, and remove food items from your menu.", btn_class: "btn btn-success", btn_path: dashboard_menu_path, btn_text: "Manage Menu" }
    ]
  end
end
