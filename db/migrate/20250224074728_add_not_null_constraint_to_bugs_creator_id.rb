class AddNotNullConstraintToBugsCreatorId < ActiveRecord::Migration[7.1]
  def change
    change_column_null :bugs, :creator_id, false
  end
end