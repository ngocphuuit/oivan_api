-require 'rails_helper'

RSpec.describe Project, type: :model do

	let(:project) {
		name: "project name",
		description: "project description",
		start_date: "2021-09-09",
		end_date: "2021-09-10"
	}

    describe "validation" do
  	    it { should validate_presence_of :name }
  	    it { should validate_presence_of :description }
  	    it { should validate_presence_of :start_date }
    end

    it "can not update start_date" do
    end
end
