# frozen_string_literal: true
module PostsHelper
  def render_post_content(post)
    case post.status
    when "cancel"
      if current_user == post.author
        post.content
      else
        "(Cancel by post author)"
      end
    when "block"
      if current_user == post.group.owner
        post.content
      else
        "(Block by group owner)"
      end
    else
      post.content
    end
  end

  def render_author_email(post)
    if current_user == post.author
      "Myself"
    else
      post.author.email
    end
  end

  def render_post_status_note(post)
    case post.status
    when "cancel"
      "(Post author canceled the post)"
    when "block"
      "(Group owner blocked the post)"
    end
  end
end
