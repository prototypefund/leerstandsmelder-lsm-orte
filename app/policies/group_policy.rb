# frozen_string_literal: true

class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, scope)
      super
      @user  = user
      @scope = scope
    end

    def resolve
      scope.all if user.admin?
    end
  end

  attr_reader :user, :group

  def initialize(user, group)
    @user = user
    @group = group
  end

  def update?
    user.admin? || user.group == @group
  end

  def edit?
    update?
  end

  def show?
    update?
  end

  def create?
    user.admin?
  end

  def new?
    create?
  end

  def destroy?
    user.admin?
  end
end
