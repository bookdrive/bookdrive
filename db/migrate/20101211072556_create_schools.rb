class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :name
      t.string :level
      t.decimal :proficiency
      t.decimal :lunch_eligibility
      t.integer :students
      t.string :website_url
      t.string :greatschools_url

      t.timestamps
    end
  end

  def self.down
    drop_table :schools
  end
end
