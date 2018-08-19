Deface::Override.new(:virtual_path => 'spree/admin/products/index',
                     :name => 'add_csv_import_modal',
                     :insert_after => "erb[silent]:contains('if can?(:create, Spree::Product)')",
                     :partial => 'spree/admin/products/csv_import_modal')
