class Group < ActiveRecord::Base

  has_many :reports, dependent: :destroy

  validates :url, format: {with: /(http(s)?:\/\/)?vk.com\/\w+(\/)?/}, presence: true
  validates :screen_name, uniqueness: true, presence: true

  default_scope -> { order 'screen_name ASC' }

  def url= attr
    super attr
    self.screen_name = attr.match(/vk.com\/(\w+)\/?/)[-1]
  end

end
