namespace :reports do
  desc "Собрает отчеты за вчера"
  task :yesterday => :environment do
    puts Date.yesterday
    from = Date.yesterday.to_time.to_i
    to = Date.today.to_time.to_i
    Group.all.each do |group|
      group.update_attribute(:gid, VkontakteClient.group_by_name(group.screen_name).gid) unless group.gid?
      print "#{group.screen_name}: "
      offset = 100
      page = 0
      report = group.reports.new date: Date.yesterday

      begin
        time_is_up = false
        posts = VkontakteClient.group_wall_posts group.gid, 100, offset*page
        posts_count = posts.shift
        posts.each do |post|
          next if post.date > to
          if post.date < from
            time_is_up = true
            break
          end
          report.likes_count += post.likes[:count]
          report.reposts_count += post.reposts[:count]
          report.comments_count += post.comments[:count]
        end
        page +=1
      end while posts.count == offset && !time_is_up
      report.save
      puts "#{report.likes_count} likes, #{report.reposts_count} reposts, #{report.comments_count} comments"
    end
  end
end