module ApplicationHelper
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

  def markdown
    Redcarpet::Markdown.new(MyRender, autolink: true, space_after_headers: true)
  end

  class MyRender < Redcarpet::Render::HTML
    def block_html(raw_html)
      if raw_html =~ /<iframe.*<\/iframe>/
        raw_html
      end
    end
  end
end
