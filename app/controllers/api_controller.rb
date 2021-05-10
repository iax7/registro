# frozen_string_literal: true

# API Controller
class ApiController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  http_basic_authenticate_with name: Rails.application.credentials.api_user,
                               password: Rails.application.credentials.api_pass,
                               except: [:ping, :cancel]

  # GET ping
  def ping
    response = {
      response: 'PONG'
    }

    render json: response, status: :ok
  end

  # GET change_pwd/:user_id/:password
  def change_pwd
    user = User.find params[:user_id]
    user.password = params[:password]
    user.save

    response = {
      id: user.id,
      status: 'ok'
    }

    render json: response, status: :ok
  rescue StandardError => e
    render_error e.message
  end

  # GET admin/:id(/:commit)
  def admin
    id = params[:id]
    commit = params[:commit] == 'true'

    begin
      user = User.lock(true).find id
      current = user.is_admin
      user.is_admin = !current
      logger.info "*** User id #{user.id} (#{user.name}) was updated to administrador: #{user.is_admin}" if commit && user.save(validate: false)
    rescue StandardError => e
      logger.fail "*** Error while working with user id #{user.id} (#{user.name}) => #{e.message}"
      render_error 'User not found'
      return
    end

    response = {
      id: user.id,
      name: user.full_name,
      email: user.email,
      is_admin: {
        old: current,
        new: user.is_admin
      },
      commited: commit,
      model_errors: user.errors.full_messages,
      model_changes: user.changes
    }

    render json: response, status: :ok
  end

  # GET cancel/:hash
  def cancel
    email_hash = params[:hash]
    user = User.includes(:registries)
               .where(registries: { event_id: Event.current.id })
               .find_by_email_hashed(email_hash)
               .first
    if user
      unless user.registries.is_confirmed
        user.registries.is_confirmed = false
        user.registries.save
      end

      response = {
        id: user.id,
        name: user.nick,
        is_cancelled: !user.registries.is_confirmed
      }
      render json: response, status: :ok
    else
      render nothing: true, status: :not_found
    end
  end

  # PUT /assist/:id
  # Marks a person as it shown to the event
  def assist
    begin
      registry_id = Guest.where(id: params[:id]).pluck(:registry_id).pop
      raise if registry_id.nil?
    rescue StandardError
      raise
    end

    registry = Registry.includes(:user, :guests).order('guests.relation, guests.age desc').find registry_id
    unless registry.is_present
      registry.is_present = true
      registry.save
    end

    registry.user.password_digest = ''
    json_hash = registry.as_json(include: [:user, :guests],
                                 methods: %i[grand_total amount_remaining paid? totals counts])
    json_hash['is_paid'] = registry.paid?
    render json: json_hash.to_json,
           status: :ok
  rescue StandardError
    render_error I18n.t('api.assist.not_found_error')
  end

  # PUT food/:day/:time/:id
  def food
    day = params[:day]
    time = params[:time]
    id = params[:id]

    unless day.match?(/^[vsdl]$/)
      render_error I18n.t('api.food.day_error')
      return
    end
    unless time.match?(/^[123]$/)
      render_error I18n.t('api.food.time_error')
      return
    end

    # All initial validations passed
    req_field_name  = "f_#{day}#{time}"
    used_field_name = "fu_#{day}#{time}"

    begin
      guest = Guest.includes(:registry).find id
      raise NotFoundError if guest.nil?
    rescue StandardError
      raise NotFoundError
    end
    raise NotPaidError unless guest.registry.paid?

    req_count = guest[req_field_name] ? 1 : 0
    used_count = guest[used_field_name]
    available_count = req_count - used_count

    # Starts logic --------------------------------------
    status = ''
    if available_count > 0
      used_count += 1
      guest[used_field_name] = used_count
      guest.save
    else
      # Not enough food bought
      status = I18n.t('api.food.consumed_error')
    end

    used_sum = Guest.joins(:registry)
                    .where(registries: { event_id: Event.current.id })
                    .sum used_field_name

    response = {
      id: guest.id,
      name: guest.nick,
      requested: req_count,
      used: used_count,
      is_adult: guest.adult?,
      used_sum: used_sum,
      status: status
    }
    render json: response, status: :ok
  rescue NotPaidError => e
    response = {
      id: guest.id,
      name: guest.nick,
      requested: req_count,
      used: used_count,
      is_adult: guest.adult?,
      used_sum: '',
      status: e.message
    }
    render json: response, status: :ok
  rescue NotFoundError => e
    response = {
      id: id,
      name: '-',
      requested: '-',
      used: '-',
      is_adult: true,
      used_sum: '',
      status: e.message
    }
    render json: response, status: :ok
  rescue StandardError => e
    render_error e
  end

  private

  def render_error(error)
    response = {
      status: error
    }
    render json: response, status: :bad_request
  end

  # Error raised when the guest is not found
  class NotFoundError < StandardError
    def initialize(msg = I18n.t('api.not_found_error'))
      super
    end
  end

  # Error raised when the food is unpaid
  class NotPaidError < StandardError
    def initialize(msg = I18n.t('api.not_paid_error'))
      super
    end
  end
end
