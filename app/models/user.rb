class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :login, :email, :password, :password_confirmation, :remember_me
  
  validates_presence_of :email
  validates_presence_of :login
  validates_presence_of :provider
  validates_presence_of :uid
  
  has_many :posts
  
  def self.new_with_session(params, session)
    super.tap do |u|
      if data = session["devise.oauth"]
        u.provider = data['provider']
        u.uid = data['uid']
        if info = data['user_info']
          u.email = info["email"] if info["email"]
          u.login = info['name']
        end
      end
    end
  end
  
  def using_oauth?
    !!self.provider
  end
  
  def valid?(options = nil)
    super(options = nil)
    unless using_oauth?
      self.errors.delete :provider
      self.errors.delete :uid
    else
      self.errors.delete :email
      self.errors.delete :password
    end
    
    return self.errors.count == 0
  end
  
  def self.find_for_oauth(oa)
    info = oa && oa['user_info']

    if info['email']
      user = User.find_by_email(info['email'])
      return user if user
    end

    user = User.where(:provider => oa['provider'], :uid => oa['uid']).first
    return user if user

    User.create( :login => info['name'],
                 :email => info['email'],
                 :uid => oa['uid'],
                 :provider => oa['provider'] )
  end
end
