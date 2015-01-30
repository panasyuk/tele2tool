require 'magic_array'

class PostArray < MagicArray

  load_limit 100

  def initialize group_id
    @group_id = "-#{group_id}"
    self.count = vk.wall.get(owner_id: @group_id, offset: 0, count: 1).first
    super
  end

  def element_source index
    vk.wall.get(owner_id: @group_id, offset: index, count: 1).last
  end

  def elements_source range_start, range_count
    result = vk.wall.get(owner_id: @group_id, offset: range_start, count: range_count)
    result.shift
    result
  end

  def vk
    vk_source = -> {VK::Client.new}
    @vk ||= vk_source.call
  end

  def search from, till
    from_index = (bsearch{ |post|
      puts post.inspect
      post.date <= from
    })
    till_index = bsearch{ |post| post.date <= till }
    self[till_index..from_index-1]
  end

  def counts from, till
    result = search from, till
    {
        likes_count: result.inject(0){|sum,post| sum+=post.likes[:count]},
        comments_count: result.inject(0){|sum,post| sum+=post.comments[:count]},
        reposts_count: result.inject(0){|sum,post| sum+=post.reposts[:count]}
    }
  end

  def bsearch &block
    first = 0
    last = count-1
    mid = first + (last - first) / 2
    #if !yield(self[0])
    #  return nil
    #elsif !yield(self[count-1])
    #  return nil
    #end
    while first<last
      if yield(self[mid])
        last = mid
      else
        first = mid + 1
      end
      mid = first + (last - first) / 2
    end
    if yield(self[last])
      last
    else
      nil
    end
  end

end
