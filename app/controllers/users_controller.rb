class UsersController < ApplicationController

  skip_before_action :auth_validation, only: [:create]

  before_action :is_owner, only: [:show, :update]
  before_action :set_user, only: [:show, :update, :destroy] 
	
  # GET /users/1
  def show		
		render json: @user    		
  end

  # POST /users
  def create
    @user = User.new(user_params)    

    if @user.save
      payload = {
        user_id: @user.id,
        token_type: 'vice_token',
        exp: 1.day.from_now.to_i
      }
  
      token = JWTValidator.encode(payload)
      render json: { user: @user, access_token: token }, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
	def update
		if @user.update(user_params)
			render json: @user
		else
			render json: @user.errors, status: :unprocessable_entity
		end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def is_owner			      
			render(json: { error: "Unauthorized" }, status: :unauthorized) unless !params[:id].nil? && params[:id].to_i == @current_user.id
		end
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:name, :username, :password)
    end
end
