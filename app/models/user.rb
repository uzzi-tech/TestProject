class User < ApplicationRecord
  has_secure_password # Enables password authentication

  enum user_type: { developer: 0, manager: 1, qa: 2 }
  validates :user_type, presence: true
  validates :email, uniqueness: true
  validates :name, presence: true

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users

  has_many :created_bugs, class_name: "Bug", foreign_key: "creator_id", dependent: :nullify
  has_many :assigned_bugs, class_name: "Bug", foreign_key: "developer_id", dependent: :nullify
end