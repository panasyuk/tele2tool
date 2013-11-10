class ReportsController < ApplicationController

  include ReportsHelper

  def index
    @groups = Group.make_report date_from, date_to
    respond_to do |format|
      format.html
      format.xls {
        send_data @groups.to_xls(only: [:screen_name, :likes_count, :comments_count, :reposts_count]),
                  type: "text/xls; charset=utf-8; header=present",
                  filename: "Tele2 Social Report (#{date_from} - #{date_to}).xls",
                  header: false
      }
    end
  end

end
