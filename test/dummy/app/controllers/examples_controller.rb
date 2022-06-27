class ExamplesController < ApplicationController
  def create
    render inline: params[:template]
  end
end
