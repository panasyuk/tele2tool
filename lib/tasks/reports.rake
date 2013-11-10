namespace :reports do
  desc "Собрает отчеты за вчера"
  task :yesterday => :environment do
    puts "Loading report for #{Date.yesterday}"
    load_reports Date.yesterday.to_time.to_i, Date.today.to_time.to_i
  end

  desc "Собрает отчеты за прошлый месяц"
  task :last_month => :environment do
    puts "Loading last month reports"
    last_month_to = Date.today.beginning_of_month
    last_month_from = last_month_to.last_month
    load_reports last_month_from.to_time.to_i, last_month_to.to_time.to_i
  end

  def load_reports from, to
    Group.all.each do |group|
      group.update_attribute(:gid, VkontakteClient.group_by_name(group.screen_name).gid) unless group.gid?
      print "#{group.screen_name}: "
      offset = 100
      page = 0
      range_likes = 0
      range_comments = 0
      range_reposts = 0
      report = group.reports.find_or_initialize_by date: Time.at(from)
      begin
        time_is_up = false
        posts = VkontakteClient.group_wall_posts group.gid, 100, offset*page
        posts.shift
        posts.each do |post|
          next if post.date > to
          if post.date < from
            time_is_up = true
            break
          end
          unless report.dated?(post.date)
            report.save if report.new_record?
            report = group.reports.find_or_initialize_by(date: Time.at(post.date))
          end
          report.likes_count += post.likes[:count]
          report.reposts_count += post.reposts[:count]
          report.comments_count += post.comments[:count]
          range_likes += post.likes[:count]
          range_comments += post.comments[:count]
          range_reposts += post.reposts[:count]
        end
        page +=1
      end while posts.count == offset && !time_is_up
      report.save if report.new_record?
      puts "#{range_likes} likes, #{range_reposts} reposts, #{range_comments} comments"
    end
  end


end