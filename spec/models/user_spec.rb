require 'rails_helper'

RSpec.describe User do
  let!(:user) { create(:user)}

  it "validates user" do
    expect(user.valid?).to eq(true)
  end
end
