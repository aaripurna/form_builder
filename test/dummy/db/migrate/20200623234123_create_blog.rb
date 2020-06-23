class CreateBlog < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
          t.text :title
          t.string :slug
          t.text :body
          t.timestamps null: false
    end
  end
end
