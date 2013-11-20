class ReportsController < ApplicationController

  def index
    respond_to do |format|
      format.html {
        @groups = Group.make_report date_from, date_to
      }
      format.xls {
        send_data Group.make_xls_report(date_from, date_to).to_stream.read,
                  type: "text/xls; charset=utf-8; header=present",
                  filename: "Tele2 Social Report (#{date_from} - #{date_to}).xlsx"
      }
    end
  end

end
