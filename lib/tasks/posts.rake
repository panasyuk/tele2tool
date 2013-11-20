require 'post_array'
namespace :posts do
  desc "Собрает посты за два последних месяца по имеющимся группам"
  task :last_two_months => :environment do
    process_posts_in Time.now.last_month.last_month.to_i, Time.now.to_i, Group.where('gid IS NOT NULL')
  end

  desc "Собрает посты за последний год по всем группам"
  task :last_year => :environment do
    process_posts_in Time.now.last_year.to_i, Time.now.to_i
  end

  desc "Собрает посты за последний год только по свежим группам"
  task :new_groups => :environment do
    process_posts_in Time.now.last_year.to_i, Time.now.to_i, Group.where(gid: nil)
  end

  def process_posts_in from, till, relation=nil
    (relation || Group.select(:id, :gid, :screen_name)).each do |group|
      group.update_attribute :gid, VkontakteClient.group_by_name(group.screen_name).gid unless group.gid
      group_name_string = "#{group.screen_name}: "
      post_array = PostArray.new group.gid
      beautyprint group_name_string+"searching posts (total: #{post_array.count})..."
      vk_posts = post_array.search from, till
      beautyprint "\r#{group_name_string}#{vk_posts.count} found"
      vk_posts.each_with_index do |vk_post, index|
        post = group.posts.find_or_initialize_by vk_id: vk_post.id
        post.update_attributes comments_count:  vk_post.comments['count'],
                               reposts_count:   vk_post.reposts['count'],
                               likes_count:     vk_post.likes['count'],
                               published_at:    Time.at(vk_post.date),
                               author_id:       vk_post.from_id,
                               type:            vk_post.type,
                               text:            vk_post.text
        beautyprint "\r#{group_name_string}processing #{(((index+1).to_f/vk_posts.count)*100).to_i}%"
      end
      beautyprint "\r#{group_name_string}updated with #{vk_posts.count} #{'post'.pluralize vk_posts.count}\n"
    end
  end

  def beautyprint what
    print ' '*(@last_length || 0)
    print what
    @last_length = what.match(/\n/) ? 0 : what.length
  end

end