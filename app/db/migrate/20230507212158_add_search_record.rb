class AddSearchRecord < ActiveRecord::Migration[7.0]
  def change
    create_table :searches do |t|
      t.string :keywords, :null => false, :default => "none"

      t.timestamps
    end
    add_index :searches, :created_at, :order => {:created_at => :desc}
  end
end
