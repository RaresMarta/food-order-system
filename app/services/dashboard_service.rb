class DashboardService
  def today_stats
    {
      orders_today: Order.where(created_at: Date.current.all_day).count,
      total_revenue_today: Order.where(created_at: Date.current.all_day).sum(:total_price),
      total_food_items: FoodItem.active.count,
      total_orders: Order.count
    }
  end

  def orders
    Order.includes(order_items: :food_item, user: :orders).recent
  end

  def food_items_for_menu(edit_id: nil)
    {
      food_item_list: FoodItem.unscoped.order(:deleted_at, :name),
      food_item: edit_id ? FoodItem.find(edit_id) : nil
    }
  end
end
