class Api::PostsController < ApplicationController

  def index
    render json: { result: "hello" }
  end

end
