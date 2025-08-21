class FoodItemService
  def create_item(food_item_params)
    food_item = FoodItem.new(food_item_params)

    if food_item.save
      { success: true, message: "Food item created.", food_item: food_item }
    else
      { success: false, message: "Failed to create food item.", food_item: food_item }
    end
  end

  def update_item(food_item, food_item_params)
    if food_item.update(food_item_params)
      { success: true, message: "Food item updated.", food_item: food_item }
    else
      { success: false, message: "Failed to update food item.", food_item: food_item }
    end
  end

  def delete_item(food_item)
    if food_item.order_items.exists?
      food_item.soft_delete!
      { success: true, message: "Food item archived.", food_item: food_item }
    else
      if food_item.destroy
        { success: true, message: "Food item deleted.", food_item: food_item }
      else
        { success: false, message: "Failed to delete food item.", food_item: food_item }
      end
    end
  end
end
