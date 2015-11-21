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
      '<span class="glyphicon glyphicon-ok text-success"/>'.html_safe
    else
      amount = number_to_currency person.amount_paid
      "#{amount}".html_safe
    end
  end

  def show_sex_symbol(ismale)
    if ismale
      '<i class="fa fa-male"></i>'.html_safe
    else
      '<i class="fa fa-female female-color"></i>'.html_safe
    end
  end

  def render_bool(is_true)
    if is_true
      '<i class="glyphicon glyphicon-ok text-success" />'.html_safe
    else
      #'<span class="glyphicon glyphicon-ban-circle text-danger" />'.html_safe
      '<i class="glyphicon glyphicon-remove text-danger" />'.html_safe
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
end
