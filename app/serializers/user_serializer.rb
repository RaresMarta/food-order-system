class UserSerializer < ApplicationSerializer
  attributes :id, :email, :name, :role

  attribute :auth, if: proc { params[:include_tokens].present? } do
    params[:include_tokens]
  end
end
