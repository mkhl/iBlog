module CommentsHelper
  def avatar(user)
    image_tag("https://internal.innoq.com/iqumf/images/users/thm-#{user}.jpg", :class => "avatar", :alt => "?")
  end
end
