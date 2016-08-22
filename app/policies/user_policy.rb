class UserPolicy < ApplicationPolicy

  def index
  end

  def new  
  end
  
  def create
  end 

  def edit?
    user.present? && record == user || user_has_power?
  end

  def update?
    edit?
  end

  private

  def user_has_power?
    user.admin? || user.moderator?
  end
  
end