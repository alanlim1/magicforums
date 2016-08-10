class CommentPolicy < ApplicationPolicy

  def edit?
    user.present? && record.user == user || user_has_power?
  end

  private

  def user_has_power?
    user.admin? || user.moderator?
  end
end