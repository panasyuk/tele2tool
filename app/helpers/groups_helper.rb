require 'uri'

module GroupsHelper

  def vk_post text=''
    uris = URI.extract text, ['http', 'https']
    result = text.dup
    uris.each do |uri|
      result.gsub! uri, "<a href=\"#{uri}\" target=\"_blank\">#{uri}</a>"
    end
    raw result
  end

end
