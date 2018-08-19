require 'csv'

Spree::Product.class_eval do

  def self.mass_import(csv_path)
    # here I use one particular separator, but need more complex solution for real app
    # more checks can be added, e.g. file content type check, encoding etc
    csv_data = CSV.read(csv_path, col_sep: "\;").map(&:compact).reject(&:empty?)
    missing_headers = ['name', 'category', 'price'] - csv_data.first.map(&:strip).map(&:downcase)
    Import::ImportProductsJob.perform_later(csv_data.to_json) if missing_headers.empty?
    missing_headers
  end
end
