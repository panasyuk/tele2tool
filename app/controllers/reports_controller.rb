class ReportsController < ApplicationController

  include ReportsHelper

  def index
    @groups = Group.make_report date_from, date_to
  end

end
