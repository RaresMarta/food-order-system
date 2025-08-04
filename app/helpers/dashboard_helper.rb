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
end
