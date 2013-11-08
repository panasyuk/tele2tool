module ReportsHelper

  def date_from
    params[:date_from] ? Date.parse(params[:date_from]) : Date.today.beginning_of_month.last_month
  end

  def date_to
    params[:date_to] ? Date.parse(params[:date_to]) : Date.today.beginning_of_month
  end

end
