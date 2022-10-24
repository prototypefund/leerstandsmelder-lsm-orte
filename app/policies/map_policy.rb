# frozen_string_literal: true

class MapPolicy < ApplicationPolicy
  attr_reader :user, :map

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
    user.admin? || record.published?
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
