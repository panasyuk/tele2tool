class Report < ActiveRecord::Base

  belongs_to :group

  delegate :screen_name, to: :group

  default_scope -> { order 'to_date DESC' }


  def self.make_report to_date
    joins(:group).where(to_date: to_date).select 'reports.*',
                                                 'groups.screen_name AS screen_name',
                                                 'groups.url AS group_url',
                                                 'groups.screen_name AS group_screen_name'
  end

  def self.dates_between from, to
    where('to_date BETWEEN ? AND ?', from, to).select('DISTINCT reports.to_date').map &:to_date
  end

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
