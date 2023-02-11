# frozen_string_literal: true

class Api::V1::DashboardController < Api::V1::ApplicationController
  # before_action :set_news, only: %i[ show edit update destroy ]

  # GET /news or /news.json
  def index
    @news = policy_scope(News)
    respond_to do |format|
      if @news
        format.json { render :index }
      else
        format.json { head :no_content }
      end
    end
  end
end
