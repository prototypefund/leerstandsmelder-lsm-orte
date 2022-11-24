# frozen_string_literal: true

class ImagePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    # raise Pundit::NotAuthorizedError, 'must be logged in' unless user
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
    # scope.where(id: record.id).exists?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
