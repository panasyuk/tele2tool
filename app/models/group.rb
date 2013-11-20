class Group < ActiveRecord::Base

  has_many :reports, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :url, format: {with: /(http(s)?:\/\/)?vk.com\/\w+(\/)?/}, presence: true
  validates :screen_name, uniqueness: true, presence: true

  default_scope -> { order 'screen_name ASC' }

  def url= attr
    super attr
    self.screen_name = attr.match(/vk.com\/([\w\W]+)\/?/)[-1]
  end

  def self.make_report from, till
    joins(:posts).select(
        'groups.*',
        'SUM(posts.likes_count) AS likes_count',
        'SUM(posts.comments_count) AS comments_count',
        'SUM(posts.reposts_count) AS reposts_count'
    ).where(
        'posts.published_at' => from..till
    ).group(
        'posts.group_id',
        'groups.id'
    )
  end

end
