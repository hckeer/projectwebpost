class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.published? || owner_or_admin?
  end

  def create?
    user&.member? || user&.admin?
  end

  def update?
    owner_or_admin?
  end

  def destroy?
    owner_or_admin?
  end

  def publish?
    owner_or_admin?
  end

  def archive?
    owner_or_admin?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.member?
        scope.where(user: user).or(scope.published)
      else
        scope.published
      end
    end
  end

  private

  def owner_or_admin?
    user&.admin? || record.user == user
  end
end
