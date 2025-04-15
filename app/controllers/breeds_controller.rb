class BreedsController < ApplicationController
  def index
    @breeds = Breed.all

    # Apply search filter
    if params[:search].present?
      @breeds = @breeds.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
    end

    # Apply group filter
    if params[:group].present?
      @breeds = @breeds.where(group: params[:group])
    end

    # Apply origin filter
    if params[:origin].present?
      @breeds = @breeds.where(origin: params[:origin])
    end

    # Apply sorting
    @breeds = case params[:sort]
      when 'name_desc'
        @breeds.order(name: :desc)
      when 'group'
        @breeds.order(:group)
      when 'origin'
        @breeds.order(:origin)
      else
        @breeds.order(:name)
    end

    # Get unique values for filters
    @groups = Breed.distinct.pluck(:group).compact.sort
    @origins = Breed.distinct.pluck(:origin).compact.sort
  end

  def show
    @breed = Breed.find(params[:id])
  end
end
