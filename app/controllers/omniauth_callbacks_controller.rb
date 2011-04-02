class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :process_oauth_callback
  def facebook; end
  def twitter; end
  def vkontakte; end
  
  protected
  def process_oauth_callback
    @user = User.find_for_oauth(env["omniauth.auth"])

    if @user.save
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", @user.provider.capitalize
      sign_in_and_redirect @user, :event => :authentication
    else
      session['devise.oauth'] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end