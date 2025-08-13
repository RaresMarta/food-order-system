module OrdersHelper
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
    base_class = "badge "
    case status.to_s
    when "placed"
      base_class + "bg-primary text-white"
    when "preparing"
      base_class + "bg-warning text-dark"
    when "ready"
      base_class + "bg-success text-white"
    when "delivered"
      base_class + "bg-secondary text-white"
    when "canceled"
      base_class + "bg-danger text-white"
    else
      base_class + "bg-secondary text-white"
    end
  end
end
