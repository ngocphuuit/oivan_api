class DevelopersController < ApplicationController
  before_action :developer_info, only: [:show, :update, :destroy]

  def index
    @developers = Developer.all

    render json: {status: "ok", data: @developers}
  end

  def show
    render json: {status: "ok", data: @developer}
  end

  def create
    byebug
    if !params[:developer][:project_ids].empty?
      project = []
      params[:developer][:project_ids].each do |id|
        if !Project.exists?(id)
          return render json: {status: "error", message: "project id is not exists"}
        end
        project.push({project_id: id})
      end
      ActiveRecord::Base.transaction do
        @developer = Developer.new(developer_params)
        @developer.save!
        @developer.project_developers.create(project)
        return render json: {status: "ok", data: @developer}
      end
    else
      render json: {status: "error", message: "can not create developer without project"}
    end
  end

  def update
    @developer.update!(developer_params)

    render json: {status: "ok", data: @developer}
  end

  def destroy
    @developer.destroy
    render json: {status: "ok"}
  end

  private

  def developer_info
    @developer = Developer.find(params[:id])
  end

  def developer_params
    params.require(:developer).permit(:firstname, :lastname)
  end

end
