class Deco::Category < ActiveRecord::Base
  belongs_to :redbox_category, class_name: 'Redbox::Category'
end
