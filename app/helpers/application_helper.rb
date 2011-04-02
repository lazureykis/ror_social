module ApplicationHelper
  
  def title
    append_this = if params[:controller] == 'users'
      case params[:action]
        when 'new' then 'Регистрация'
        when 'create' then 'Регистрация'
        when 'show' then @user.login
        else 'Пользователи'
      end
    elsif params[:controller] == 'user_sessions'
      'Log in'
    else
      nil
    end
    
    append_this ? append_this + ' / ror_social' : 'ror_social'
  end
end
