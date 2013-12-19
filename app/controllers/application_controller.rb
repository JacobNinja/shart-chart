require 'shart_chart'
require 'graph_data'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def graph
    analysis_results = ShartChart.pooooop(File.read(params[:filename]))
    @graph_data = GraphData.new(analysis_results)
  end

end
