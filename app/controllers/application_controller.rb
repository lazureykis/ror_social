class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  
  def find_or_create_user_by_omniauth(oa)
    info = oa && oa['user_info']
    
    if info['email']
      user = User.where(:email => info['email']).first
      return user if user
    end
    
    user = User.where(:provider => oa['provider'], :uid => oa['uid']).first
    return user if user
    
    user = User.new(
      :login => info['name'],
      :email => info['email'],
      :image_url => info['image'],
      :uid => oa['uid'],
      :provider => oa['provider']
    )

    user.save
  
    return user
  end
end