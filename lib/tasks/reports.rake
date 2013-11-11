namespace :reports do
  desc "Собрает отчеты только за прошлый месяц. Для получения достоверных данных необходимо запускать первого числа каждого месяца."
  task :last_month => :environment do

    if Date.today.day != 1 && !ENV['DATE']
      puts 'Today is not the first day of month!'
      return
    end

    puts "Loading last month reports"
    what_date = Date.today
    last_month_to = what_date.beginning_of_month
    last_month_from = last_month_to.last_month
    load_reports last_month_from.to_time.to_i, last_month_to.to_time.to_i

  end

  def load_reports from, to
    Group.all.each do |group|
      group.update_attribute(:gid, VkontakteClient.group_by_name(group.screen_name).gid) unless group.gid?
      print "#{group.screen_name}: "
      offset = 100
      page = 0
      report = group.reports.new from_date: Time.at(from), to_date: Time.at(to)
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
          report.likes_count += post.likes[:count]
          report.reposts_count += post.reposts[:count]
          report.comments_count += post.comments[:count]
        end
        page +=1
      end while posts.count == offset && !time_is_up
      report.save if report.new_record?
      puts "#{report.likes_count} likes, #{report.reposts_count} reposts, #{report.comments_count} comments"
    end
  end

end