FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_deco/factories'
  factory :deco_category, :class => 'Deco::Category' do
    name "My Category"
    redbox_category nil
  end
end
