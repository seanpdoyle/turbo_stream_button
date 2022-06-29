class ExamplesController < ApplicationController
  def create
    fail unless Rails.env.test?

    render inline: params[:template]
  end
end
