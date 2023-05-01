class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts do |t|
      t.bigint :original_index, null: false, default: 0
      t.text :content
      t.timestamps
    end
    add_index :prompts, :created_at
  end
end
