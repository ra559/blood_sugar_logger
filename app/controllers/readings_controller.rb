class ReadingsController < ApplicationController
  def index
    @readings_by_week = Reading.all.group_by { |r| r.created_at.to_date.cweek }
    @readings_by_month = Reading.all.group_by { |r| r.created_at.strftime("%Y-%m") }
    @readings_by_year = Reading.all.group_by { |r| r.created_at.year }

    # Date range for chart (default: last 7 days)
    @end_date = if params[:end_date].present?
                  Date.parse(params[:end_date]) rescue Time.zone.today
                else
                  Time.zone.today
                end

    @start_date = if params[:start_date].present?
                    Date.parse(params[:start_date]) rescue (@end_date - 6.days)
                  else
                    @end_date - 6.days
                  end

    range_start = @start_date.beginning_of_day
    range_end   = @end_date.end_of_day

    # Prepare data for Chartkick within the selected range - format: { "date" => value }
    readings_in_range = Reading.where(created_at: range_start..range_end).order(:created_at)

    @chart_data = readings_in_range.map do |reading|
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
