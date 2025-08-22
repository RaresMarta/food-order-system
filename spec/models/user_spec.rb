require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  describe "associations" do
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
    it { is_expected.to have_many(:food_items).through(:cart_items) }
    it { is_expected.to have_many(:orders) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to define_enum_for(:role).with_values(customer: 0, admin: 1) }
  end

  describe "callbacks" do
    it "downcases email on save" do
      user.email = "UPPER@EXAMPLE.COM"
      user.save!
      expect(user.reload.email).to eq("upper@example.com")
    end
  end

  describe "dependent destroys" do
    it "destroys cart_items when user is destroyed" do
      user = create(:user)
      create(:cart_item, user: user)
      expect { user.destroy }.to change { CartItem.count }.by(-1)
    end
  end
end
