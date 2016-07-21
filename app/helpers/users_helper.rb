module UsersHelper

  # 返回指定用户的 gravatar
  def gravatar_for(user, options={size: 80})
    return false if user.nil?
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
