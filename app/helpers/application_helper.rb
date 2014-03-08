module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def active_tab(*args)
    if args.length == 1
       @active_tab = args[0]
    else
      @active_tab || nil
    end
  end
end
