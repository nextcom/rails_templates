# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Sets page title and inserts header (default: h1).
  def title(title, tag = :h1)
    @company_name = "<span class='company'>#{@company.company_name}:</span> " if @company && controller_name != 'companies' && admin?
    @title = "#{@company_name}#{title.gsub(/\<[\/A-Za-z\s\=\'\"]+>/, '')}"
    content_for :title do
      "#{@title.downcase} | ".gsub(/\<[^\>]+\>/, "") if title
    end
    return content_tag(tag, @title)
  end
  
  # Sets page title only (see #title above).
  def title_only(title)
    content_for :title do
      "#{title.downcase} | ".gsub(/\<[^\>]+\>/, "") if title
    end
  end
  
  # Sets corrent text for submit button based on current action.
  def submit_text(options = {})
    if ['create', 'new'].include?(action_name)
      return options[:create] || 'Create'
    else
      return options[:update] || 'Update'
    end
  end
  
  # Wraps block in div tags with class .page_nav to centralize page nav formatting.
  def page_nav(&proc)
    opening = "<div class=\"page_nav\">"
    concat(opening)
    yield
    closing = "</div>"
    concat(closing)
  end
  
  # Crops string and adds "..." to the end at specified character (defaults to 20 characters).
  def partial_string(string, length = 20)
    new_string = string.to_s[0..length]
    new_string << "..." if string.length > length
    return new_string
  end
  
end
