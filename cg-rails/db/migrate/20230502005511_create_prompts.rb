class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts do |t|
      t.bigint :original_index, :null => false, :default => 0
      t.text :content, :null => false, :default => "no prompt given"

      t.timestamps
    end
    add_index :prompts, :created_at, :order => {:created_at => :desc}
  end
end
