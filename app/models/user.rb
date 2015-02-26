class User < ActiveRecord::Base
	has_many :authentications
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
				:omniauthable, :omniauth_providers => [:facebook]
	def self.from_omniauth(auth)
		where(provider: auth.provider, uid:auth.uid).first_or_create do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]
		end
		.joins(:authentications).where(authentications: { provider: auth.provider, uid: auth.uid }).first_or_create do |user|
			user.authentications.provider = auth.provider
			user.authentications.uid = auth.uid
		end
	end

	def apply_omniauth(omniauth)
		self.email = omniauth['userinfo']['email'] if email.blank?
		authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
	end

	def password_required?
		(authentications.empty? || !password.blank?) && super
	end
end
