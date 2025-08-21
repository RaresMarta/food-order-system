# frozen_string_literal: true

class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :verify_authenticity_token

  def create
    build_resource(sign_up_params)

    if resource.save
      render json: { ok: true, user: { id: resource.id, email: resource.email } }, status: :created
    else
      render json: { ok: false, errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
