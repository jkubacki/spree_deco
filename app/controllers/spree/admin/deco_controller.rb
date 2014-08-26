class Spree::Admin::DecoController < Spree::Admin::BaseController

  def index
    @categories = Deco::Category.not_set
    @redbox_categories = Redbox::Category.all
  end

  def edit
    @categories = Deco::Category.set
    @redbox_categories = Redbox::Category.all
  end

  def update
    params[:category].each do |deco_name, redbox_id|

    end
  end

end
