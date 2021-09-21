class Project < ApplicationRecord
    has_many :project_developers, dependent: :destroy
    has_many :developers, through: :project_developers
    has_many :project_technologies, dependent: :destroy
    has_many :technologies, through: :project_technologies

    validates :name, :description, :start_date, presence: true
    validate :end_date_cannot_be_before_start_date

    acts_as_paranoid

	def end_date_cannot_be_before_start_date
	    if end_date.present? && end_date < start_date
	      	errors.add(:end_date, "can't be before the start date")
	    end
	end 

    def self.get_all_dev_and_tech
        where("deleted_at IS ?", nil).includes(:developers, :technologies).as_json(include: [:developers, :technologies])
    end
end
