class User < ActiveRecord::Base

  def self.authenticate(email, password)
    user = User.where(:email => email).first
    if user && user.password == password
      return user
    else return nil
    end
  end
end
