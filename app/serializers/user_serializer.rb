class UserSerializer < ApplicationSerializer
  attributes :id, :email, :name, :role, :created_at, :updated_at

  attribute :admin do |user|
    user.admin?
  end
end
