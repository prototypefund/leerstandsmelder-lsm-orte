# frozen_string_literal: true

class Api::V1::AnnotationsController < Api::V1::ApplicationController
  before_action :set_annotation, only: %i[edit show update destroy]
  before_action :authenticate_user!, except: %i[show]

  # GET  /annotation.json
  def index
    @annotations = policy_scope(Annotations)
  end

  def create
    authorize Annotation
    @annotation = Annotation.new(annotation_params)
    @annotation.user = current_user
    @annotation.published = true
    respond_to do |format|
      if @annotation.save
        format.json { render :show, status: :created, annotation: @annotation }
      else
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /annotation/1 or /annotation/1.json
  def update
    respond_to do |format|
      if @annotation.update(annotation_params)
        format.json { render :show, status: :updated, annotation: @annotation }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @annotation.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def set_annotation
    @annotation = Annotation.find(params[:id])
    authorize @annotation
  end

  def annotation_params
    params.require(:annotation).permit(:title, :status, :text, :annotation_id, :source, :audio, :place_id, :person_id, tag_list: [], images: [])
  end
end
