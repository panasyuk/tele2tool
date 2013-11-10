class Report < ActiveRecord::Base

  belongs_to :group

  def dated? check_date
    date == format_date(check_date)
  end

  def date= attr
    super format_date(attr)
  end

  private

    def format_date attr_date
      case attr_date
        when Date then attr_date
        when Numeric then Time.at(attr_date).to_date
        when Time then attr_date.to_date
      end
    end

end
