# frozen_string_literal: true

# Default rails helper
module ApplicationHelper
  def set_session_vars(user_id, is_admin, reg_id = nil)
    session[:user_id] = user_id
    session[:is_admin] = is_admin
    session[:reg_id] = reg_id
  end

  def session_active?
    session[:user_id].present?
  end

  def session_id
    session_active? ? session[:user_id] : nil
  end

  def session_reg
    session_active? ? session[:reg_id] : nil
  end

  def admin?
    session[:is_admin]
  end

  def my_reg?(reg_id)
    session_reg == reg_id
  end

  def fa_text(icon_name, text = nil, class_name: nil, style: nil)
    name = icon_name.is_a?(Symbol) ? icon_name.to_s.tr('_', '-') : icon_name
    text = "&nbsp;#{text}" unless text.nil?
    # Named Args
    style_text = %( style="#{style}") unless style.nil?
    fa_icon = name.gsub(/fa-/, '')

    %(<i class="fas fa-#{fa_icon} fa-fw #{class_name}"#{style_text} aria-hidden="true"></i>#{text}).html_safe
  end

  # NAV -----------------------------------------------------------
  def nav_li_link(text, link_path)
    active_class = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: "nav-item #{active_class}") do
      link_to text, link_path, class: 'nav-link'
    end
  end

  def nav_dropdown_link(text, link_path)
    active_class = current_page?(link_path) ? 'active' : ''
    link_to text, link_path, class: "dropdown-item #{active_class}"
  end

  def show_sex_symbol(is_male, show_text: false, short: false)
    text = show_text ? sex_text(is_male, short: short) : ''
    if is_male
      %(<i class="fas fa-male"></i>#{text}).html_safe
    else
      %(<i class="fas fa-female female-color"></i>#{text}).html_safe
    end
  end

  def sex_text(is_male, short: false)
    text = '&nbsp;'
    text + if short
             is_male ? t('common.male_short') : t('common.female_short')
           else
             is_male ? t('common.male') : t('common.female')
           end
  end

  def render_bool(value, render_false = true, options = {})
    if value
      color = options.key?(:colorless) ? '' : 'text-success'
      %(<i class="fas fa-check #{color}"></i>).html_safe
    else
      color = options.key?(:colorless) ? '' : 'text-danger'
      %(<i class="fas fa-times #{color}"></i>).html_safe if render_false
    end
  end

  def render_bool_reversed(is_true)
    if is_true
      '<i class="fa fa-check-square-o text-danger"></i>'.html_safe
    else
      '<i class="fa fa-square-o text-success"></i>'.html_safe
    end
  end

  def dim_zeros(number, custom_char_zero = '0')
    return number unless number&.zero?

    %(<span class="text-muted">#{custom_char_zero}</span>).html_safe
  end

  def dim_zeros_currency(number, decimals: 0)
    return number_to_currency(number, precision: decimals).html_safe unless number.zero?

    %(<span class="text-muted">#{number_to_currency 0, precision: decimals}</span>).html_safe
  end

  def paid_format_colors(paid, to_pay, decimals: 0)
    amount  = paid.nil? ? 0 : paid
    pending = to_pay.nil? ? 0 : to_pay
    class_name = case amount <=> pending
                 when 0 then 'text-success'
                 when -1 then 'text-danger'
                 when 1 then 'text-warning'
                 end
    # class_name = 'text-muted' if amount.zero?

    %(<span class="#{class_name}">#{number_to_currency paid, precision: decimals}</span>).html_safe
  end

  def make_bold(text, make_it = true)
    return text.html_safe unless make_it

    %(<strong>#{text}</strong>).html_safe
  end

  def icon_cost_render(bool, text)
    return unless bool

    check_box_html = %(<span class="fas fa-check text-success bool"></span>)
    %(#{check_box_html}<span class="text-muted cost" style="display: none;">#{dim_zeros text, '-'}</span>).html_safe
  end

  def hash_to_dots(hash)
    json_str = hash.to_json
    JSON.parse(json_str, object_class: OpenStruct)
  end

  def api_auth_base64
    auth = "#{Rails.application.credentials.api_user}:#{Rails.application.credentials.api_pass}"
    Base64.strict_encode64 auth
  end

  def badge_class(bool)
    bool ? 'info' : 'danger'
  end
end
