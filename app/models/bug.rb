class Bug < ApplicationRecord
  enum bug_type: { feature_request: 0, bug: 1 }

  # Define separate status mappings
  FEATURE_STATUSES = { new_feature: 0, started: 1, completed: 2 }
  BUG_STATUSES = { new_bug: 4, started: 1, resolved: 3 }

  validates :title, presence: true, uniqueness: { scope: :project_id }
  validates :bug_type, presence: true
  validates :status, presence: true
  validates :creator_id, presence: true  

  belongs_to :project
  belongs_to :creator, class_name: "User"  
  belongs_to :developer, class_name: "User", optional: true  

  validate :validate_status_based_on_type

  private

  def validate_status_based_on_type
    if feature_request? && !FEATURE_STATUSES.values.include?(status)
      errors.add(:status, "Invalid status for feature")
    elsif bug? && !BUG_STATUSES.values.include?(status)
      errors.add(:status, "Invalid status for bug")
    end
  end  
end
