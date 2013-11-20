class Post < ActiveRecord::Base
  belongs_to :group
  paginates_per 10

  class << self

    %i{likes reposts comments}.each do |resource|
      method_name = "#{resource}_count"
      define_method method_name do
        select("sum(#{method_name}) as #{method_name}")[0].send(method_name) || 0
      end
    end

  end


end
