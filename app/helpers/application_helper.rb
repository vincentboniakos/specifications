module ApplicationHelper
  #Return a title on a per-page basis
  def title
    base_title = "Specifications"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end   
  end
  
  def title_header
    @title_header ||= @title
  end
  
  def sidebar
    @actions
  end
end
