class User < ApplicationRecord
    # has_many :microposts, dependent: :destroy
    # has_many :active_relationships, class_name: "Relationship",
    #                                 foreign_key: "follower_id",
    #                                 dependent: :destroy 
    # has_many :passive_relationships, class_name: "Relationship",
    #                                   foreign_key: "followed_id",
    #                                   dependent: :destroy 
    # has_many :following, through: :active_relationships, source: :followed
    # has_many :followers, through: :passive_relationships, source: :follower
    has_many :specializations, dependent: :destroy 
    has_many :jobs, dependent: :destroy
    has_many :requests, dependent: :destroy



    attr_accessor :remember_token, :activation_token, :reset_token 

#ApplicationRecord class inherites ActiveRecord::Base
#Which means that User class will have all the functionality of ActiveRecord::Base 

    before_save :downcase_email
    before_create :create_activation_digest
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX},
                        uniqueness: true
    validates :role, presence: true

    # Freelancer 1
    # Client 0


    has_secure_password 
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true


    
    
# Returns the hash digest of the given string.

    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end


#Return a random tocken

    def User.new_token 
       SecureRandom.urlsafe_base64
    end

#Remember a user in the database for in persistent sessions.

    def remember 
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
      remember_digest
    end

#Retuens a session token to prevent session hijacking
#We resuse the remember digest for convenience.

    def session_token
      remember_digest || remember
    end

#Returns true if the given token matches the digest

    def authenticated?(attribute, token)
      digest = self.send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
      update_attribute(:remember_digest, nil)
    end

    def activate 
      update_columns(activated: true, activated_at: Time.zone.now)
    end

    def send_activation_email 
      UserMailer.account_activation(self).deliver_now
    end

    #sets the password reset attributes
    def create_reset_digest
      self.reset_token = User.new_token 
      update_columns(reset_digest: User.digest(reset_token) , reset_sent_at: Time.zone.now )
    end

    #send password reset email
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now 
    end

    #Returns true if a password reset has expired.
    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end

  private
    #Converts email to all lowercase
    def downcase_email
      self.email = email.downcase 
    end

    #Creates and assigns the activation token and digest before creation of user

    def create_activation_digest
      self.activation_token = User.new_token 
      self.activation_digest = User.digest(activation_token)
    end

end
