class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum user_type: { developer: 0, manager: 1, qa:2 }
  validates :user_type, presence: true
  validates :email, uniqueness: true
  validates :name, presence: true

  has_many :project_users
  has_many :projects, through: :project_users

  has_many :created_bugs, class_name: "Bug", foreign_key: "creator_id"
  has_many :assigned_bugs, class_name: "Bug", foreign_key: "developer_id"
end
