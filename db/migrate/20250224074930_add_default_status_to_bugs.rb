class AddDefaultStatusToBugs < ActiveRecord::Migration[7.1]
  def change
    change_column_default :bugs, :status, 0  # Default to "new"
  end
end