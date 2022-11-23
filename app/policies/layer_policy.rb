# frozen_string_literal: true

class LayerPolicy < ApplicationPolicy
  attr_reader :user, :layer

  def initialize(user, layer)
    @user = user
    @layer = layer
  end

  def show?
    user&.admin? || layer.published?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.blank?
        scope.where(published: true)
      else
        scope.where(published: true)
      end
    end
  end
end
