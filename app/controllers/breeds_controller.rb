class BreedsController < ApplicationController
  def index
    @breeds = if params[:search].present?
      Breed.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
    else
      Breed.all
    end
  end

  def show
    @breed = Breed.find(params[:id])
  end
end
