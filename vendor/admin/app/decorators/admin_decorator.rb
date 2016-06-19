# frozen_string_literal: true
class AdminDecorator < ApplicationDecorator

  def self.show_time(*columns, **options)
    columns.each do |column|
      define_method(column) do
        h.show_time model.public_send(column), options
      end
    end
  end

  def tag(name, content = nil, options = {}, &block)
    h.content_tag(name, content, options, &block)
  end

  def path
    model
  end

  def generate_user_link(user_id, html: {})
    id = format('%08d', user_id)
    text = id
    h.link_to text, h.user_path(user_id), html
  end

  def edit_button
    h.link_to "Редактировать", [:edit, model], class: "btn btn-info"
  end

  def remove_button(options = {})
    remove_link options.reverse_merge(class: "btn btn-danger")
  end

  def remove_link(options = {})
    namespace = options.delete(:namespace)

    options = {
      method: :delete,
      class:  options[:class],
      data:   { confirm: "Вы уверены?" },
    }

    h.link_to "Удалить", [*Array(namespace), model], options
  end

  def per_page_options
    %w[25 50 100].map { |e| ["by #{e}", e] }
  end
end
