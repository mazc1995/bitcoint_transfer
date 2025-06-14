class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def create_transaction?
    current_user.id == user.id
  end

  def show_transaction?
    current_user.id == user.id
  end

  def index_transactions?
    current_user.id == user.id
  end
end