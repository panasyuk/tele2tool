class VkontakteClient

  class << self

    def user_by_name(screen_name)
      connection.users.get(uids: screen_name, fields: 'photo_medium_rec,screen_name').first

    rescue VkontakteApi::Error => error
      if error.error_code == 113 # Invalid user id
        nil
      else
        raise error
      end
    end


    def group_by_name(screen_name)
      group_info = connection.groups.get_by_id(gids: screen_name).first
      if group_info.name == 'DELETED'
        nil
      else
        group_info
      end

    rescue VkontakteApi::Error => error
      if error.error_code == 100 # Invalid group id
        nil
      else
        raise error
      end
    end

    def video_by_id(video_id)
      video_full_data = authorized_connection.video.get(videos: video_id)
      videos_count = video_full_data.shift
      [videos_count.to_i, video_full_data]
    end

    def search_groups(name)
      groups = authorized_connection.groups.search(q: name)
      groups_count = groups.shift
      [groups_count.to_i, groups]
    end

    def search_posts(main_tag, start_time=0)
      start_time = 0 if start_time < 0
      posts = connection.newsfeed.search({q: "##{main_tag}", extended: 1, count: 100, start_time: start_time})
      posts.shift
      posts
    end

    def group_wall_posts owner_id, count=100, offset=0
      wall_posts "-#{owner_id}", count, offset
    end

    def wall_posts owner_id, count=100, offset=0
      connection.wall.get owner_id: owner_id, offset: offset, count: count
    end

    # Get vk post url
    #
    # @param vk_post [VkPost]
    # @return [String] url of the vk post
    def post_url(vk_post)
      "https://vk.com/wall#{vk_post.owner_id}_#{vk_post.post_id}"
    end

    private

    def connection(renew = false)
      create = -> { VkontakteApi::Client.new }

      if renew
        @connection = create.call
      else
        @connection ||= create.call
      end
    end

    def authorized_connection(renew = false)
      create = -> { VkontakteApi::Client.new(VK_TOKEN) }

      if renew
        @authorized_connection = create.call
      else
        @authorized_connection ||= create.call
      end
    end

  end # class << self
end
