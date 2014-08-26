class CreateDecoCategories < ActiveRecord::Migration
  def change
    create_table :deco_categories do |t|
      t.string :name
      t.belongs_to :redbox_category, index: true

      t.timestamps
    end
  end
end
