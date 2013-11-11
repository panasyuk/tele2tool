class ChangeDateToToDateAndAddFromDateToReports < ActiveRecord::Migration
  def change
    rename_column :reports, :date, :to_date
    add_column :reports, :from_date, :date
  end
end
