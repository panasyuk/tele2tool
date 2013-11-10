class Group < ActiveRecord::Base

  has_many :reports, dependent: :destroy

  validates :url, format: {with: /(http(s)?:\/\/)?vk.com\/\w+(\/)?/}, presence: true
  validates :screen_name, uniqueness: true, presence: true

  default_scope -> { order 'screen_name ASC' }

  def self.make_report from, to
    joins(:reports)
    .where('reports.date BETWEEN ? AND ?', from, to)
    .select('groups.*, SUM(reports.likes_count) as likes_count, SUM(reports.reposts_count) as reposts_count, SUM(reports.comments_count) as comments_count')
    .group 'groups.id'
  end

  def url= attr
    super attr
    self.screen_name = attr.match(/vk.com\/(\w+)\/?/)[-1]
  end

end
