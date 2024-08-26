module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_authenticity_token

      def create
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          sign_in(user)
          render json: { message: 'Logged in successfully.', user: user_data(user) }, status: :ok
        else
          render json: { message: 'Invalid email or password.' }, status: :unauthorized
        end
      end

      def destroy
        if current_user
          sign_out(current_user)
          render json: { message: 'Logged out successfully.' }, status: :ok
        else
          render json: { message: 'Logout failed. User not signed in.' }, status: :unauthorized
        end
      end

      private

      def user_data(user)
        {
          id: user.id,
          email: user.email,
          created_at: user.created_at,
          updated_at: user.updated_at,
          jwt: request.env['warden-jwt_auth.token']
        }
      end
    end
  end
end
