# frozen_string_literal: true

class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :email, :nickname, :role_keys, :created_at, :updated_at, :confirmed, :blocked, :message_me, :notify, :share_email, :accept_terms
end
