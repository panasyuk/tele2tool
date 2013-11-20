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
    select(
        'groups.*',
        'SUM(posts.likes_count) AS likes_count',
        'SUM(posts.comments_count) AS comments_count',
        'SUM(posts.reposts_count) AS reposts_count',
        'posts.*'
    ).where(
        'posts.published_at' => from..till
    ).group(
        'posts.id',
        'posts.group_id',
        'groups.id'
    )
  end

  def self.make_xls_report from, till
    relation = includes(:posts)
    .where(
        'posts.published_at' => from..till
    ).group(
        'posts.id',
        'posts.group_id',
        'groups.id'
    ).references(:posts)
    xls = Axlsx::Package.new
    sheet = xls.workbook.add_worksheet name: 'Статистика'
    sheet.add_row ['группа', 'лайки', 'комментарии', 'репосты']
    relation.each do |group|
      sheet.add_row [group.screen_name, group.posts.likes_count, group.posts.comments_count, group.posts.reposts_count]
    end
    relation.each do |group|
      sheet = xls.workbook.add_worksheet name: group.screen_name
      sheet.add_row ['Дата', 'Текст', 'Кол-во лайков', 'Кол-во комментариев', 'Кол-во репостов']
      group.posts.each do |post|
        sheet.add_row [post.published_at, post.text, post.likes_count, post.comments_count, post.reposts_count]
      end
    end
    xls
  end

end
