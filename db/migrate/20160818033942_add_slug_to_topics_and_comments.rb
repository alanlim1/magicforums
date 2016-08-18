class AddSlugToTopicsAndComments < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :slug, :string, unique: true
    add_column :comments, :slug, :string, unique: true
  end
end
