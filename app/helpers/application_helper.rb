module ApplicationHelper
  def user_avatar(name, size: 40, style: "thumbs")
    name_param = name.present? ? name : "Anonymous"

    begin
      # DiceBear APIを使用してアバターを生成
      image_tag "https://api.dicebear.com/7.x/#{style}/svg?seed=#{ERB::Util.url_encode(name_param)}&size=#{size}",
                alt: "#{name_param}'s avatar",
                class: "rounded-full block",
                style: "width: #{size}px; height: #{size}px; margin: 0 auto;",
                loading: "lazy"
    rescue => e
      # Fallback to simple gradient with initials
      content_tag :div,
                  name_param.first.upcase,
                  class: "inline-flex items-center justify-center text-white font-bold rounded-full",
                  style: "width: #{size}px; height: #{size}px; margin: 0 auto; background: linear-gradient(45deg, #667eea 0%, #764ba2 100%); font-size: #{size * 0.4}px;"
    end
  end
end
