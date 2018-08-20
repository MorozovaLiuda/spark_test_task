require 'csv'

class Import::ImportProductsJob < ApplicationJob
  queue_as :default

  def perform(json_data)
    products = []
    csv_data = JSON.parse(json_data)
    headers = csv_data.shift.map(&:to_s)
    csv_data.each do |row|
      raw_attributes = headers.zip(row).reject{|k, v| k.blank? }.to_h
      product = Spree::Product.new(process_attributes(raw_attributes))
      # this is tricky one, not sure about it
      product.master.stock_items.build(stock_location: Spree::StockLocation.last, count_on_hand: raw_attributes['stock_total'])
      products << product
    end
    # Batch import, much faster https://github.com/zdennis/activerecord-import
    # This will fail for already added products, as slug should be unique, we can use
    # smth like `.where(slug: 'slug').first_or_initialize` inside the loop
    Spree::Product.import(products, recursive: true)
  end

  private

  def process_attributes(raw_attributes)
    default_category = Spree::ShippingCategory.find_by_name('Default').id
    raw_attributes['shipping_category_id'] = Spree::ShippingCategory.find_by_name(raw_attributes['category'])&.id || default_category
    raw_attributes['price'] = raw_attributes['price'].to_f
    raw_attributes.except('category', 'stock_total')
  end
end
