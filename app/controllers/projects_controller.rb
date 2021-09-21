class ProjectsController < ApplicationController
	before_action :project_info, only: [:show, :update, :destroy]

	def index
		@projects = Project.get_all_dev_and_tech
		render json: {status: "ok", data: @projects}
	end

	def show
		@developers = @project.developers.pluck(:id)
		@technologies = @project.technologies.pluck(:id)
		render json: {status: "ok", data: @project, devs: @developers, techs: @technologies}
	end

	def create
	    if params[:project][:developer_ids].present? and !params[:project][:developer_ids].empty? 
	      developers = []
	      params[:project][:developer_ids].each do |id|
	        if !Developer.exists?(id)
	          return render json: {status: "error", message: "Developer id is not exists"}
	        end
	        developers.push({developer_id: id})
	      end
	    end

	    if params[:project][:technology_ids].present? and !params[:project][:technology_ids].empty?
	      technologies = []
	      params[:project][:technology_ids].each do |id|
	        if !Technology.exists?(id)
	          return render json: {status: "error", message: "Technology id is not exists"}
	        end
	        technologies.push({technology_id: id})
	      end
	    end

	    Project.transaction do
		    @project = Project.new(project_params)
		    @project.save!

		    @project.project_developers.create(developers)
		    @project.project_technologies.create(technologies)
	    	render json: {status: "ok", data: @project}
	    end
	end

	def update
		ActiveRecord::Base.transaction do
			# add and remove developer
			if params[:project][:developer_ids].present?
		      cur_developer_ids = @project.developers.pluck(:id)
		      new_developer_ids = params[:project][:developer_ids]
		      rm_dev_ids = cur_developer_ids - new_developer_ids
		      add_dev_ids = new_developer_ids - cur_developer_ids

		      # remove
		      rm_dev_ids.each do |dev_id|
		      	dev = Developer.find(dev_id)
		      	if dev.projects.where.not(id: @project.id).empty?
					dev.destroy
				end
		      end
		      @project.project_developers.where(developer_id: rm_dev_ids).destroy_all

		      # add
		      dev_arr = []
		      add_dev_ids.each do |id|
		        if !Developer.exists?(id)
		          return render json: {status: "error", message: "Developer id is not exists"}
		        end
		        dev_arr.push({developer_id: id})
		      end
			  @project.project_developers.create(dev_arr)	      
		    end

		    # add and remove technology
		    if params[:project][:technology_ids].present?
		      cur_technology_ids = @project.technologies.pluck(:id)
		      new_technology_ids = params[:project][:technology_ids]
		      rm_tech_ids = cur_technology_ids - new_technology_ids
		      add_tech_ids = new_technology_ids - cur_technology_ids

		      # remove
		      @project.project_technologies.where(technology_id: rm_tech_ids).destroy_all

		      # add
		      tech_arr = []
		      add_tech_ids.each do |id|
		        if !Technology.exists?(id)
		          return render json: {status: "error", message: "Technology id is not exists"}
		        end
		        tech_arr.push({technology_id: id})
		      end
			  @project.project_technologies.create(tech_arr)
		    end

			@project.update!(project_update_params)
	    	render json: {status: "ok", data: @project}
	    end
	end

	def destroy
		ActiveRecord::Base.transaction do
			@developers = @project.developers
			@developers.each do |developer|
				if developer.projects.where.not(id: @project.id).empty?
					developer.destroy
				end
			end
			@project.destroy
			render json: {status: "ok"}
		end
	end

	private

	def project_info
		@project = Project.find(params[:id])
	end

	def project_params
		params.require(:project).permit(:name, :description, :start_date, :end_date)
	end

	def project_update_params
		params.require(:project).permit(:name, :description, :end_date)
	end
end
