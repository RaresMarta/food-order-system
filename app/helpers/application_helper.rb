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
end
