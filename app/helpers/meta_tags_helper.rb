# frozen_string_literal: true

# Sets Title and Description for pages using application layout
module MetaTagsHelper
  def meta_title
    title = content_for?(:meta_title) ? :meta_title : t("meta.title")
    default = "#{title} - #{Rails.configuration.app[:author]}"
    content_for?(:meta_title) ? content_for(:meta_title) : default
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : t("meta.description")
  end
end
