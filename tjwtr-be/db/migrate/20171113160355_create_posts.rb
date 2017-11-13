class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.int :user_id
      t.string :content

      t.timestamps
    end
  end
end
