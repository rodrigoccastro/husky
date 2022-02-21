class UserService

  def find_user_by_email(email:)
    User.where(email: email).take
  end

  def find_user_by_email_and_token(email:, value:)
    user = User.where(email: email, token_temp: value).take
  end

  def find_user_by_token(value:)
    user = User.where(token_main: value).take
  end

  def new_user(email:)
    user = User.create(email: email, token_temp: token)
    UserMailer.with(user: user).send_mail_token.deliver_later
    user
  end

  def generate_token(user:)
    user.token_temp = token
    if user.save
      UserMailer.with(user: user).send_mail_token.deliver_later
      return true
    end
    return false
  end

  def has_token?(user:)
    user.token_main.present?
  end

  def activate_token(user:)
    user.update(token_main: user.token_temp, token_temp: nil)
  end

  private

  def token
    rand(36**8).to_s(36)
  end

end
