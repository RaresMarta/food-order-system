class FoodItemsController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_food_item, only: [:show, :update, :destroy]

  # GET /food_items
  def index
    render json: FoodItem.all.map { |item| food_item_json(item) }
  end

  # GET /food_items/:id
  def show
    render json: food_item_json(@food_item)
  end

  # POST /food_items
  def create
    @food_item = FoodItem.new(food_item_params)
    if @food_item.save
      render json: food_item_json(@food_item), status: :created, location: @food_item
    else
      render_errors(@food_item)
    end
  end

  # PATCH/PUT /food_items/:id
  def update
    if @food_item.update(food_item_params)
      render json: food_item_json(@food_item)
    else
      render_errors(@food_item)
    end
  end

  # DELETE /food_items/:id
  def destroy
    @food_item.destroy
    head :no_content
  end

  private

  def set_food_item
    @food_item = FoodItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "FoodItem not found" }, status: :not_found
  end

  def food_item_params
    params.require(:food_item).permit(:name, :category, :price, :vegetarian, :image)
  end

  def food_item_json(item)
    {
      id:         item.id,
      name:       item.name,
      category:   item.category,
      price:      item.price.to_f,
      vegetarian: item.vegetarian,
      image_url:  item.image.attached? ? url_for(item.image) : nil
    }
  end

  def render_errors(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end
