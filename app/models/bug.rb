class Bug < ApplicationRecord
  enum bug_type: { feature: 0, bug: 1 }
  enum status: { new: 0, started: 1, completed: 2, resolved: 3 }

  validates :title, presence: true, uniqueness: { scope: :project_id }
  validates :bug_type, presence: true
  validates :status, presence: true

  belongs_to :project
  belongs_to :creator, class_name: "User"
  belongs_to :developer, class_name: "User", optional: true

  mount_uploader :screenshot, ScreenshotUploader
end
