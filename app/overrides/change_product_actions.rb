Deface::Override.new(:virtual_path => 'spree/admin/products/index',
                     :name => 'add_csv_import_button',
                     :insert_before => "erb[silent]:contains('if can?(:create, Spree::Product)')",
                     :partial => 'spree/admin/products/csv_import')
