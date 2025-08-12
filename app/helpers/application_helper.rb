module ApplicationHelper
  def full_title(page_title = "")
    base_title = "Eureka Caffe"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def category_options
    [
      [ "All",           "default" ],
      [ "Entrees",       "entrees" ],
      [ "Main courses",  "main-courses" ],
      [ "Second courses", "second-courses" ],
      [ "Salads",        "salads" ],
      [ "Pizza",         "pizza" ],
      [ "Desserts",      "desserts" ]
    ]
  end

  def sort_options
    [
      [ "Default",               "default" ],
      [ "Price: Low to High",    "asc" ],
      [ "Price: High to Low",    "desc" ]
    ]
  end

  def payment_options
    [
      [ "Credit Card",  "credit_card" ],
      [ "Cash",         "cash" ],
      [ "PayPal",       "paypal" ]
    ]
  end

  def cart_table_headers
    ["Image", "Item Name", "Category", "Price", "Quantity", "Subtotal", "Actions"]
  end

  def cart_item_count
    return 0 unless logged_in? && current_user

    current_user.cart_items.sum(:quantity)
  end

  def current_user_admin?
    logged_in? && current_user.admin?
  end

  def order_status_class(status)
    case status.to_s
    when "placed"
      "bg-blue-100 text-blue-800"
    when "preparing"
      "bg-yellow-100 text-yellow-800"
    when "ready"
      "bg-green-100 text-green-800"
    when "delivered"
      "bg-gray-100 text-gray-800"
    when "canceled"
      "bg-red-100 text-red-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end

  def order_status_badge_class(status)
    case status.to_s
    when "placed"
      "bg-primary text-white"
    when "preparing"
      "bg-warning text-dark"
    when "ready"
      "bg-success text-white"
    when "delivered"
      "bg-secondary text-white"
    when "canceled"
      "bg-danger text-white"
    else
      "bg-secondary text-white"
    end
  end
end
