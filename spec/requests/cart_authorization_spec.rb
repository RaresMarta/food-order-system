require 'rails_helper'

RSpec.describe "Cart Authorization", type: :request do
  let(:food_item) { create(:food_item) }

  describe "POST /cart_items (Add to Cart)" do
    context "when user is NOT logged in" do
      it "redirects to login page and prevents cart item creation" do
        expect {
          post cart_items_path, params: { food_item_id: food_item.id }
        }.not_to change(CartItem, :count)

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this page")
      end

      it "cannot access cart index page" do
        get cart_items_path

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this page")
      end
    end

    context "when user IS logged in" do
      let(:user) { create(:user) }

      before do
        # Simulate login by directly setting session (cleaner for tests)
        # This is equivalent to what happens after successful login
        post login_path, params: { email: user.email, password: user.password }
        # Alternative approach: directly set session
        # But request specs don't have direct session access, so we use login
      end

      it "successfully adds item to cart" do
        expect {
          post cart_items_path, params: { food_item_id: food_item.id }
        }.to change(CartItem, :count).by(1)

        cart_item = CartItem.last
        expect(cart_item.user).to eq(user)
        expect(cart_item.food_item).to eq(food_item)
        expect(cart_item.quantity).to eq(1)
      end

      it "can access cart index page" do
        get cart_items_path

        expect(response).to have_http_status(:success)
      end
    end
  end
end
