module OrdersHelper
  def order_status_class(status)
    status_str = status.to_s.strip.downcase

    case status_str
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

  def order_status_badge_class(status)
    status_str = status.to_s.strip.downcase

    base_class = "badge "
    case status_str
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
