FactoryBot.define do
  factory :order do
    association :user
    status { :placed }
    payment_method { %w[credit_card paypal cash].sample }
    total_price { 0.0 }

    after(:create) do |order|
      create_list(:order_item, 3, order: order)
      order.update(total_price: order.calculate_total)
    end
  end
end
