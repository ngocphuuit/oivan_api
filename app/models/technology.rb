class Technology < ApplicationRecord
	has_many :project_technologies, dependent: :destroy
    has_many :projects, through: :project_technologies

    validates :name, presence: true
end
