class CreateBugs < ActiveRecord::Migration[7.1]
  def change
    create_table :bugs do |t|
      t.string :title, null: false
      t.text :description
      t.date :deadline
      t.string :screenshot
      t.integer :bug_type, null: false
      t.integer :status, null: false
      t.references :project, null: false, foreign_key: true
      t.bigint :creator_id
      t.bigint :developer_id

      t.timestamps
    end
    add_index :bugs, [:title, :project_id], unique: true
    add_foreign_key :bugs, :users, column: :creator_id
    add_foreign_key :bugs, :users, column: :developer_id
  end
end
