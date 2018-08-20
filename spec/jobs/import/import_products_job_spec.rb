require "rails_helper"

describe Import::ImportProductsJob do
  describe "#perform" do

    it 'imports products' do
      # factory_bot can be used here, just very simple factory, so leaved here
      default_shipping_category = Spree::ShippingCategory.create(name: 'Default')
      stock_location = Spree::StockLocation.create(name: 'test')
      csv_content = CSV.read(File.absolute_path('spec/fixtures/products.csv'), col_sep: "\;").map(&:compact).reject(&:empty?)
      expect { Import::ImportProductsJob.perform_now(csv_content.to_json) }.to change(Spree::Product, :count).by(3)
      # we can additionlly check newly imported products fields, if they are correct
    end
  end
end
