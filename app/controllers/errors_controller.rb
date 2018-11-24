# frozen_string_literal: true

# Used to show custom error pages with the app look and feel
class ErrorsController < ApplicationController
  def not_found
    @err = {
      msg: t('errors_controller.not_found.msg'),
      code: '404'
    }
    respond_to do |format|
      format.html { render template: 'errors/error', layout: 'layouts/application', status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end

  def unprocessable
    @err = {
      msg: t('errors_controller.unprocessable.msg'),
      code: '422'
    }
    respond_to do |format|
      format.html { render template: 'errors/error', layout: 'layouts/application', status: 422 }
      format.all  { render nothing: true, status: 422 }
    end
  end

  def internal_server_error
    @err = {
      msg: t('errors_controller.internal_server_error.msg'),
      code: '500'
    }
    respond_to do |format|
      format.html { render template: 'errors/error', layout: 'layouts/application', status: 500 }
      format.all  { render nothing: true, status: 500 }
    end
    # render 'errors/error'
  end
end
