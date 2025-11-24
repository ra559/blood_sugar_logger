class ReadingsController < ApplicationController
  def index
    @readings_by_week = Reading.all.group_by { |r| r.created_at.to_date.cweek }
    @readings_by_month = Reading.all.group_by { |r| r.created_at.strftime("%Y-%m") }
    @readings_by_year = Reading.all.group_by { |r| r.created_at.year }
    
    # Prepare data for Chartkick - format: { "date" => value }
    @chart_data = Reading.order(:created_at).map do |reading|
      [reading.created_at.strftime("%Y-%m-%d %H:%M"), reading.blood_sugar]
    end.to_h
  end

  def new
    @reading = Reading.new
  end

  def create
    @reading = Reading.new(reading_params)
    if @reading.save
      redirect_to root_path, notice: "Reading saved!"
    else
      render :new
    end
  end

  def edit
    @reading = Reading.find(params[:id])
  end

  def update
    @reading = Reading.find(params[:id])
    if @reading.update(reading_params)
      redirect_to root_path, notice: "Reading updated!"
    else
      render :edit
    end
  end

  private

  def reading_params
    params.require(:reading).permit(:blood_sugar)
  end
end
