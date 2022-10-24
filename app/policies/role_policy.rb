# frozen_string_literal: true

class RolePolicy < ApplicationPolicy
  attr_reader :user, :role

  def index
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def show?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(published: true)
      end
    end
  end
end
