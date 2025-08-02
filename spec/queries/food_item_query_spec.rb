require 'rails_helper'

RSpec.describe FoodItemQuery do
  let!(:pizza) { create(:food_item, category: "Pizza", vegetarian: true, price: 10) }
  let!(:burger) { create(:food_item, category: "Burger", vegetarian: false, price: 15) }

  it "filters by category" do
    result = described_class.new(params: filters(category: "Pizza")).call
    expect(result).to include(pizza)
    expect(result).not_to include(burger)
  end

  it "filters by vegetarian" do
    result = described_class.new(params: filters(vegetarian: true)).call
    expect(result).to include(pizza)
    expect(result).not_to include(burger)
  end

  it "sorts by price ascending" do
    result = described_class.new(params: filters(sort: "asc")).call
    expect(result.first).to eq(pizza)
    expect(result.last).to eq(burger)
  end

  it "filters by multiple criteria" do
    result = described_class.new(params: filters(category: "Pizza", vegetarian: true, min: 5, max: 15)).call
    expect(result).to include(pizza)
    expect(result).not_to include(burger)
  end
end
