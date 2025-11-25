class UserPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end

  def show?
    user&.admin? || user == record
  end

  def update?
    user&.admin? || user == record
  end

  def destroy?
    user&.admin? && user != record
  end

  def promote?
    user&.admin? && user != record
  end

  def demote?
    user&.admin? && user != record
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.none
      end
    end
  end
end
