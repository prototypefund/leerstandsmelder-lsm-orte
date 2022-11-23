# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Maps" do
  get "/api/v1/maps" do
    example "Listing maps" do
      do_request

      expect(status).to eq 200
    end
  end
end
