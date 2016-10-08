class CreateMessage < ActiveRecord::Migration

  def change
    create_table :messages do |t|
      t.string :safe_link
      t.string :text
      t.integer :max_count
      t.datetime :max_date

      t.timestamps
    end

    add_index :messages, :safe_link
    add_index :messages, :max_count
    add_index :messages, :max_date

  end
end
