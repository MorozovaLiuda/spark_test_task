Spree::Admin::ProductsController.class_eval do

  # Create and import actions could be merged actually, didn't want to refator all that
  # create stuff within test task
  def import
    # moved all import stuff to model, to avoid extra checks in controller
    missing_headers = Spree::Product.mass_import(params[:file].path)
    if missing_headers.any?
      flash[:error] = Spree.t('products_import.missing_headers', missing_headers: missing_headers.join(', '))
    else
      flash[:notice] = Spree.t('products_import.in_progress')
    end
    redirect_to admin_products_path
  end
end

