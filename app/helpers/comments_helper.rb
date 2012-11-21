module CommentsHelper
  def avatar(user)
    image_tag("https://testldap.innoq.com/liqid2/users/#{user}/avatar", :class => "avatar", :alt => "#{user}")
  end
end
