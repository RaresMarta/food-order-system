class UserSerializer < ApplicationSerializer
  attributes :id, :name, :email, :role, :created_at, :updated_at

	attribute :auth, if: proc { params[:include_tokens].present? } do
		params[:include_tokens]
	end
end
