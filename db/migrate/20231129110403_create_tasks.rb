class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.references :user
      t.string :event
      t.date :ymd
      t.string :category
      t.timestamps null: false
    end
  end
end