# frozen_string_literal: true

class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :nickname

  all_attrs = %i[email role_keys created_at updated_at confirmed blocked message_me notify share_email accept_terms]

  all_attrs.each do |field|
    attribute field do |user, params|
      user[field] if Pundit.policy(params[:current_user], user).permitted_attributes.include?(field)
    end
  end

  attribute :roles do |user, params|
    user.roles if Pundit.policy(params[:current_user], user).permitted_attributes.include?(:roles)
  end
  attribute :role_keys do |user, params|
    user.role_keys if Pundit.policy(params[:current_user], user).permitted_attributes.include?(:role_keys)
  end
end
