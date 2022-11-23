# frozen_string_literal: true

class AnnotationPolicy < ApplicationPolicy
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
    user&.admin? || record.published?
  end

  class Scope < Scope
    def resolve
      # puts user&.inspect
      if user&.admin?
        scope.all
      elsif user&.blank?
        scope.where(published: true)
      else
        scope.where(published: true)
      end
    end
    private

    attr_reader :user, :scope
  end
end
