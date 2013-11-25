class Group < ActiveRecord::Base

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

  def self.make_xls_report from, till
    till+=1
    relation = joins(:posts).select(
        'groups.*',
        'SUM(posts.likes_count) AS likes_count',
        'SUM(posts.comments_count) AS comments_count',
        'SUM(posts.reposts_count) AS reposts_count'
    ).where(
        'posts.published_at' => from..till
    ).group(
        'posts.group_id',
        'groups.id'
    ).order('groups.screen_name ASC')
    xls = Axlsx::Package.new
    time_style = xls.workbook.styles.add_style :num_fmt => Axlsx::NUM_FMT_YYYYMMDDHHMMSS
    sheet = xls.workbook.add_worksheet name: 'Статистика'
    sheet.add_row ['группа', 'лайки', 'комментарии', 'репосты']
    relation.each_with_index do |group, index|
      sheet.add_row [group.screen_name, group.likes_count, group.comments_count, group.reposts_count]
      sheet.add_hyperlink :location => "##{group.screen_name}", :ref => "A#{index+2}"
    end
    relation = includes(:posts)
    .where(
        'posts.published_at' => from..till
    ).group(
        'posts.id',
        'posts.group_id',
        'groups.id'
    ).order('posts.published_at DESC').references(:posts)
    relation.each do |group|
      sheet = xls.workbook.add_worksheet name: group.screen_name
      sheet.add_row ['Дата', 'Текст', 'Кол-во лайков', 'Кол-во комментариев', 'Кол-во репостов', 'URL']
      posts_count = 1
      group.posts.each do |post|
        posts_count+=1
        sheet.add_row [post.published_at, post.text.gsub(/<\/?[^>]+?>/, ''), post.likes_count, post.comments_count, post.reposts_count, "#{group.url}?w=wall-#{group.gid}_#{post.vk_id}"], style: [time_style, nil, nil, nil, nil, nil]
      end

      sheet.add_row [nil, nil, "=SUM(C2:C#{posts_count})", "=SUM(D2:D#{posts_count})", "=SUM(E2:E#{posts_count})"]
      sheet.column_info[0].width=17
      sheet.column_info[1].width=50
      sheet.column_info[2].width=12
      sheet.column_info[3].width=18
      sheet.column_info[4].width=13
    end
    xls
  end

end
