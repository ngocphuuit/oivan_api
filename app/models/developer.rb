class Developer < ApplicationRecord
	has_many :project_developers, dependent: :destroy
    has_many :projects, through: :project_developers

    validates :firstname, :lastname, presence: true
    validates :firstname, uniqueness: { scope: :lastname }
end
