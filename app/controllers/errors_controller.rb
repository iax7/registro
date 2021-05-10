# frozen_string_literal: true

# Used to show custom error pages with the app look and feel
class ErrorsController < ApplicationController
  def not_found
    @err = {
      msg: t('errors_controller.not_found.msg'),
      code: '404'
    }
    respond_to do |format|
      format.html { render template: 'errors/error', layout: 'layouts/application', status: :not_found }
      format.all  { render nothing: true, status: :not_found }
    end
  end

  def unprocessable
    @err = {
      msg: t('errors_controller.unprocessable.msg'),
      code: '422'
    }
    respond_to do |format|
      format.html { render template: 'errors/error', layout: 'layouts/application', status: :unprocessable_entity }
      format.all  { render nothing: true, status: :unprocessable_entity }
    end
  end

  def internal_server_error
    @err = {
      msg: t('errors_controller.internal_server_error.msg'),
      code: '500'
    }
    respond_to do |format|
      format.html { render template: 'errors/error', layout: 'layouts/application', status: :internal_server_error }
      format.all  { render nothing: true, status: :internal_server_error }
    end
    # render 'errors/error'
  end
end
