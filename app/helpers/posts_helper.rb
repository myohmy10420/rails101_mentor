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
      "(Block by group owner)"
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
    return "" if current_user != post.author

    case post.status
    when "cancel"
      "(You have been cancel the post)"
    end
  end
end
