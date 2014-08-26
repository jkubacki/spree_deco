class Deco::Migrate
  def read_xmls(cache = false)
    parser = Nori.new
    products = []
    if cache
      products = YAML::load open('temp/deco_products').read
    else
      limit = 100000
      (0..limit).step(500) do |n|
        begin
          filename = "http://shop.partydeco.pl/xls/ex_url_PL_wszystkie_kategorie_#{n}.xml"
          xml = open(filename).read
          puts filename
          products += parser.parse(xml)['offers']['offer']
        rescue OpenURI::HTTPError
          break
        end
      end
      open('temp/deco_products', 'w').write YAML::dump(products)
    end
    products
  end

  def update_categories
    category_list.each do |category_name|
      Deco::Category.find_or_create_by(name: category_name)
    end
  end


  def category_list
    products = read_xmls
    categories = []
    products.each do |product|
      categories << product['category'] unless categories.include?(product['category'])
    end
    categories
  end

  def add_to_redbox
    # FileUtils.rm_rf Dir.glob("#{Rails.root}/temp/img/*")
    products = read_xmls true
    products.each do |product|
      # redbox_category = Redbox::Category.find_by(deco_id: product['category']) # TODO
      # return nil if redbox_category.blank?
      redbox = Redbox::Product.new
      redbox.symbol = 'DC-' + product['code']
      # redbox.category_id = redbox_category.id
      set_names redbox, product['name']
      redbox.price_buy = product['net'].to_f
      redbox.vat = product['vat']
      # redbox.deco_stock = product['stock'] # TODO add column to database
      redbox.image = self.images_redbox product['image'] # TODO
      puts redbox.inspect
      break
    end
  end

  def images_redbox(image_string)
    require 'php_serialize'
    images = images image_string
    redbox_array = []
    images.each do |image|
      require 'open-uri'
      uniq_id = open('http://red-box.pl/uniqid.php').read
      open("temp/img/#{uniq_id}.jpg", 'wb') do |file|
        file << open(image).read
      end
      imagename = 'NAME'
      redbox_array << {name: imagename, width: 750, height: 600}
    end
    PHP.serialize(redbox_array)
  end

  def images(image_string)
    imgs = image_string.split(';')
    images = []
    imgs.each do |img|
      images << img.strip
    end
    images
  end

  private
    def set_names(redbox_product, name)
      redbox_product.name = name
      redbox_product.name_storage = name
      redbox_product.name_invoice = name
      redbox_product.name_eprice = name
      redbox_product.name_eprice2 = name
      redbox_product.name_eprice3 = name
      redbox_product.name_istore = name
    end
    
    def check_sku_uniqueness
      products = read_xmls true
      skus = {}
      codes = []
      products.each do |product|
        code = product['code']
        codes << code
        if skus.has_key? code
          skus[code] += 1
        else
          skus[code] = 1
        end
      end
      skus.each do |sku, count|
        puts sku if count > 1
      end
      puts 'codes: ' + codes.count.to_s
      puts 'uniq: ' + codes.uniq.count.to_s
      nil
    end
end