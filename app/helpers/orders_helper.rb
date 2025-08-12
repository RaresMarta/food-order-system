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
