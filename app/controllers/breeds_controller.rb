class BreedsController < ApplicationController
  def index
    @breeds = if params[:search].present?
      Breed.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
    else
      Breed.all
    end

    @breeds = case params[:sort]
      when 'name_asc'
        @breeds.order(name: :asc)
      when 'name_desc'
        @breeds.order(name: :desc)
      when 'group'
        @breeds.order(:group)
      when 'origin'
        @breeds.order(:origin)
      else
        @breeds.order(:name)
    end
  end

  def show
    @breed = Breed.find(params[:id])
  end
end
