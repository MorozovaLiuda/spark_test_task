require "rails_helper"

RSpec.describe Spree::Product, type: :model do

  describe '#mass_import' do
    context 'success' do
      it 'schedules import job' do
        expect do
          described_class.mass_import(File.absolute_path('spec/fixtures/products.csv'))
        end.to have_enqueued_job(Import::ImportProductsJob)
      end
    end

    context 'missing headers' do
      it 'returns missing headers' do
        expect do
          result = described_class.mass_import(File.absolute_path('spec/fixtures/missing_headers_products.csv'))
          expect(result).to eq(['name'])
        end.not_to have_enqueued_job(Import::ImportProductsJob)
      end
    end
  end
end
