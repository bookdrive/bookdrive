# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { ' &raquo; '.html_safe + page_title.to_s.html_safe }
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end

  def admin_page
    @is_admin_page = true
  end
  
  def admin_page?
    @is_admin_page
  end

  def hold_flash_notices
    @hold_flash_notices = true
  end
  
  def hold_flash_notices?
    @hold_flash_notices
  end
  
  
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def tab_for(name, options, condition=nil)
    condition = current_page?(options) if condition.nil?
    link_to_unless(condition, name, options) do
      content_tag(:span, name)
    end
  end
  
end