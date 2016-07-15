module ApplicationHelper

  # 根据所在的页面返回完整的标题
  def full_title(title = "")
    base_title = "Ruby on Rails Tutorial Sample App"
    if title.empty?
      base_title
    else
      title + " | " + base_title
    end
    # title.empty? ? base_title : (title + " | " + base_title)
  end
end
