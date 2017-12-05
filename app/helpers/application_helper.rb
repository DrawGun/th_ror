module ApplicationHelper
  def navbar_link(title, href, method = :get)
    link_classes = "nav-link #{href === request.path ? 'active' :  ''}".strip
    link_to(title, href, class: link_classes, method: method)
  end

  def vote_link(title, question, answer = nil)
    klazz = ['voting', 'btn']

    type = if title == '+'
      klazz << 'btn-success'
      :vote_up
    else
      klazz << 'btn-danger'
      :vote_down
    end

    url = polymorphic_path([type, question, answer])

    link_to(title, url, remote: true, method: :patch, class: klazz.join(' '))
  end
end
