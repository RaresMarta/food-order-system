module FiltersHelper
  def filters(overrides = {})
    {
      category: nil,
      vegetarian: nil,
      min: nil,
      max: nil,
      sort: nil
    }.merge(overrides)
  end
end
