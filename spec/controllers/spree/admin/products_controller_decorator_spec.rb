require 'rails_helper'

RSpec.describe Spree::Admin::ProductsController, type: :controller do
  stub_authorization!
  routes { Spree::Core::Engine.routes }

  describe 'POST import' do
    context 'successfull import' do
    it 'returns notice' do
      post :import, params: {
        file: fixture_file_upload(File.absolute_path('spec/fixtures/products.csv'), 'text/csv')
      }
      expect(response).to redirect_to(admin_products_path)
      expect(flash[:notice]).to eq('Thanks! Your file is being processed. Please come back in few moments to see newly imported products.')
    end
  end

    context 'failed import' do
      it 'returns error' do
        post :import, params: {
          file: fixture_file_upload(File.absolute_path('spec/fixtures/missing_headers_products.csv'), 'text/csv')
        }
        expect(response).to redirect_to(admin_products_path)
        expect(flash[:error]).to eq('Could not import CSV file without required columns: name.')
      end
    end
  end
end
