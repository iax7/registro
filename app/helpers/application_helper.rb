module ApplicationHelper
  def dimzeros(num, custom_char_zero = '0')
    if num == 0
      "<span class=\"text-muted\">#{custom_char_zero}</span>".html_safe
    else
      num
    end
  end

  def paid_format_colors(paid, to_paid)
    format = case
                 when paid == to_paid then 'text-success'
                 when paid < to_paid  then 'text-danger'
                 when paid > to_paid  then 'text-warning'
                 when paid == 0       then 'text-muted'
             end
    "<span class=\"#{format}\">#{number_to_currency paid}</span>".html_safe
  end

  # To deprecate
  def paid(person)
    if person.is_paid
      '<i class="fa fa-check text-success"\></i>'.html_safe
    else
      amount = number_to_currency person.amount_paid
      "#{amount}".html_safe
    end
  end

  def show_sex_symbol(ismale)
    if ismale
      '<i class="fa fa-male fa-fw"></i>'.html_safe
    else
      '<i class="fa fa-female female-color fa-fw"></i>'.html_safe
    end
  end

  def render_bool(is_true)
    if is_true
      '<i class="fa fa-check text-success"></i>'.html_safe
    else
      #'<span class="glyphicon glyphicon-ban-circle text-danger" />'.html_safe
      '<i class="fa fa-times text-danger"></i>'.html_safe
    end
  end

  def render_bool_text(is_true)
    if is_true
      'Sí'
    else
      'No'
    end
  end

  def render_bool_reversed(is_true)
    if is_true
      '<i class="fa fa-check-square-o text-danger"></i>'.html_safe
    else
      '<i class="fa fa-square-o text-success"></i>'.html_safe
    end
  end

  def get_gravatar_src(email, size = 60)
    require 'digest/md5'
    email_address = email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "http://www.gravatar.com/avatar/#{hash}?s=#{size}"
  end

  def expand_totals_label(text)
    case text
      when 'C'
        return 'Confirmados'
      when 'A'
        return 'Todos'
      when 'N'
        return 'Cancelados'
      when 'P'
        return 'Asistieron'
      when 'CR'
        return 'Con Restantes'
      when 'AR'
        return 'Tod Restantes'
    end
  end

  def markdown(textmd)
    options = {
        filter_html:     false,
        xhtml:            true,
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})

    markdown.render(textmd).html_safe
  end

  def render_fa_image(string)
    groups = /{(fa-\w+)}(.*)/.match(string)
    if groups.nil?
      string
    else
      "<i class='fa #{groups[1]}' aria-hidden='true'></i>#{groups[2]}".html_safe
    end
  end

  def api_auth_base64
    auth = "#{Rails.application.config.api_user}:#{Rails.application.config.api_pass}"
    Base64.strict_encode64 auth
  end

  def fa_with_text(icon_name, text, icon_back = nil)
    # %r() is another way to write a regular expression.
    # %q() is another way to write a single-quoted string (and can be multi-line, which is useful)
    # %Q() gives a double-quoted string and escapes double quotes
    # %() or %[] or %{} is like %Q
    # %x() is a shell command
    # %i() gives an array of symbols (Ruby >= 2.0.0)
    # %s() turns foo into a symbol (:foo)
    if icon_back.nil?
      if icon_name == ''
        %Q(<i class="fa fa-square fa-fw" style="visibility: hidden;" aria-hidden="true"></i>&nbsp;#{text}).html_safe
      else
        %Q(<i class="fa fa-#{icon_name} fa-fw" aria-hidden="true"></i>&nbsp;#{text}).html_safe
      end
    else
      %Q(<span class="fa-stack fa-lg">
           <i class="fa fa-#{icon_back} fa-stack-2x"></i>
           <i class="fa fa-#{icon_name} fa-stack-1x fa-inverse"></i>
         </span>&nbsp;#{text}).html_safe
    end
  end

  def nav_li_link(text, link_path)
    active_class = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => active_class) do
      link_to text, link_path
    end
  end

end
