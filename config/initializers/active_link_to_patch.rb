module ActiveLinkTo
  def active_link_to(*args, &block)
    if block_given?
      name          = capture(&block)
      options       = args[0] || {}
      html_options  = args[1] || {}
    else
      name          = args[0]
      options       = args[1] || {}
      html_options  = args[2] || {}
    end
    url = url_for(options)

    active_options = {}
    link_options = {}
    html_options.each do |k, v|
      if %i[active class_active class_inactive active_disable wrap_tag].member?(k)
        active_options[k] = v
      else
        link_options[k] = v
      end
    end

    css_class = link_options.delete(:class).to_s + ' '
    css_class << active_link_to_class(url, active_options)
    css_class.strip!

    wrap_class = link_options.delete(:wrap_class).to_s + ' '
    wrap_class << active_link_to_class(url, active_options)
    wrap_class.strip!

    wrap_tag = active_options[:wrap_tag].present? ? active_options[:wrap_tag] : nil
    link_options[:class] = css_class if css_class.present?

    link =
      if active_options[:active_disable] === true && is_active_link?(url, active_options[:active])
        content_tag(:span, name, link_options)
      else
        link_to(name, url, link_options)
      end

    wrap_tag ? content_tag(wrap_tag, link, class: (wrap_class if wrap_class.present?)) : link
  end
end
