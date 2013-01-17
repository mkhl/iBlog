module CommentsHelper
  def avatar(user)
    image_tag("https://intern.innoq.com/liqid2/users/#{user}/avatar", :class => "avatar", :alt => "#{user}")
  end
end
