class FoodItemQuery
  def initialize(params:, scope: FoodItem.all)
    @params = params
    @scope = scope
  end

  def call
    @scope
      .filter_by_category(@params[:category])
      .vegetarian_only(@params[:vegetarian])
      .price_between(@params[:min], @params[:max])
      .sorted_by_price(@params[:sort])
  end
end
