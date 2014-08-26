Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                     :name => "add_deco_configuration",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
                     :text => "<li><a href=\"/deco\">#{Spree.t(:deco)}</a></li>",
                     :disabled => false)