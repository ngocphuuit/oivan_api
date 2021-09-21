class TechnologiesController < ApplicationController
  before_action :technology_info, only: [:show, :update, :destroy]

  def index
    @technologies = Technology.all

    render json: {status: "ok", data: @technologies}
  end

  def show
    render json: {status: "ok", data: @technology}
  end

  def create
    @technology = Technology.new(technology_params)
    @technology.save!

    render json: {status: "ok", data: @technology}
  end

  def update
    @technology.update!(technology_params)

    render json: {status: "ok", data: @technology}
  end

  def destroy
    if @technology.projects.empty?
      @technology.destroy
      render json: {status: "ok"}
    else
      render json: {status: "error", message: "can not delete this technology"}
    end
  end

  private

  def technology_info
    @technology = Technology.find(params[:id])
  end

  def technology_params
    params.require(:technology).permit(:name)
  end
end
