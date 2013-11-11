class ReportsController < ApplicationController

  include ReportsHelper

  def index
    @dates = Report.dates_between date_from, date_to
  end

  def show
    @reports = Report.make_report params[:to_date]
    respond_to do |format|
      format.html
      format.xls {
        send_data @reports.to_xls(only: [:screen_name, :likes_count, :comments_count, :reposts_count]),
                  type: "text/xls; charset=utf-8; header=present",
                  filename: "Tele2 Social Report (#{@reports.first.from_date} - #{@reports.first.to_date}).xls"
      }
    end
  end

end
