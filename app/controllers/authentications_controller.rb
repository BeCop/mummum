class AuthenticationsController < Devise::OmniauthCallbacksController
  before_action :set_authentication, only: [:destroy]

  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
  end


	def facebook
		omniauth = request.env["omniauth.auth"]

		# try to find if the omniauth authentication exists
		authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
		if authentication
			# redirect to the user with that authentication and log in
			flash[:notice] = 'Signed in successfully.'
			sign_in_and_redirect authentication.user
    elsif current_user
			# attach authentication to logged in user
			current_user.authentications.create!(:provider => auth['provider'], :uid => omniauth['uid'])
			format.html { redirect_to authentications_url, notice: 'Authentication successul'} 
		else
			# Create or look for user with this email
			#@user = User.from_omniauth(request.env["omniauth.auth"])
			#sign_in_and_redirect @user
			user = User.where(email: omniauth['info']['email']).first_or_create do |user|
				user = omniauth.info.email
			end

			# add authentication to that user
			user.apply_omniauth(omniauth)
			if user.save
				flash[:notice] = 'Signed in successfully.'
				sign_in_and_redirect user
			else
				# validation fails, redirect to get more information
				session["devise.ominauth"] = omniauth.except('extra')
				redirect_to user_registration_url
			end
		end
	end


  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication.destroy
		flash[:notice] = 'Authentication was successfully destroyed'
		respond_with(@authentication, :location => authentications_url)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authentication
      @authentication = current_user.authentications.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authentication_params
      params.require(:authentication).permit(:user_id, :provider, :uid)
    end
end
