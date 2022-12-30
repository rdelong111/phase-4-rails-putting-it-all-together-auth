class RecipesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def index
    user = find_user
    if user
      render json: user.recipes, status: :created
    else
      not_authorized
    end
  end

  def create
    user = find_user
    if user
      recipe = user.recipes.create!(recipe_params)
      render json: recipe, status: :created
    else
      not_authorized
    end
  end

  private

  def find_user
    User.find_by(id: session[:user_id])
  end

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end

  def not_authorized
    render json: {errors: ["Not authorized"]}, status: :unauthorized
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end
