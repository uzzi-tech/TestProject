class Project < ApplicationRecord
  validates :name, presence: true

  has_many :project_users, class_name: "ProjectUser", dependent: :destroy
  has_many :users, through: :project_users

  has_many :bugs, dependent: :destroy
end
