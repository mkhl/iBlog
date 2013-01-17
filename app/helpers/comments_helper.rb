module CommentsHelper
  def avatar(user)
    image_tag("https://intern.innoq.com/liqid2/users/#{user}/avatar/32x32", :class => "avatar", :alt => "#{user}")
  end
end
