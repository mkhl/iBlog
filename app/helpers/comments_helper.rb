module CommentsHelper
  def avatar(user)
    image_tag("https://intern.innoq.com/liqid/users/#{user}/avatar/64x64", :class => "avatar", :alt => "#{user}")
  end
end
