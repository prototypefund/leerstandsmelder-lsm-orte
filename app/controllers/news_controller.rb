# frozen_string_literal: true

class NewsController < ApplicationController
  before_action :set_news, only: %i[show edit update destroy]

  # GET /news or /news.json
  def index
    @news = News.all
  end

  # GET /news/1 or /news/1.json
  def show; end

  # GET /news/new
  def new
    @news = News.new
  end

  # GET /news/1/edit
  def edit; end

  # POST /news or /news.json
  def create
    puts 'OOOOOOOO'
    puts news_params.inspect

    @news = News.new(news_params)

    @news.user = current_user
    puts @news.inspect

    respond_to do |format|
      if @news.save
        format.html { redirect_to news_url(@news), notice: 'News was successfully created.' }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news/1 or /news/1.json
  def update
    puts 'xxx'
    puts news_params.inspect

    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to news_url(@news), notice: 'News was successfully updated.' }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1 or /news/1.json
  def destroy
    @news.destroy

    respond_to do |format|
      format.html { redirect_to news_index_url, notice: 'News was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_news
    @news = News.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def news_params
    puts 'parammmmmmmmmmmmmms'
    puts params

    params.require(:news).permit(:title, :body, :published, map_ids: [])
  end
end
