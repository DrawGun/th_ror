module ApplicationHelper
  def navbar_link(title, href, method = :get)
    link_classes = "nav-link #{href === request.path ? 'active' :  ''}".strip
    link_to(title, href, class: link_classes, method: method)
  end
end
