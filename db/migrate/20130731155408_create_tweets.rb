class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :name
      t.string :content
      t.string :job_id
      t.references :user
      
      t.timestamps
    end
  end
end
