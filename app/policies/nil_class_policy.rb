# frozen_string_literal: true

class NilClassPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      puts 'NilClassResolve'
      raise Pundit::NotDefinedError, 'Cannot scope NilClass'
    end
  end

  def show?
    false # Nobody can see nothing
  end
end
