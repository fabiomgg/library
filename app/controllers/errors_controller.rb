class ErrorsController < ApplicationController
    def unauthorized
      render status: :forbidden
    end
  end