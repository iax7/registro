class BaseApiController < ActionController::Base
  #before_action :authenticate
  http_basic_authenticate_with name: Rails.application.config.api_user,
                               password: Rails.application.config.api_pass,
                               except: [ :ping, :cancel ]

  class NotPaidError < StandardError
    def initialize(msg='Error! No se han pagado los platillos.')
      super
    end
  end

  def ping
    response = Hash.new
    response[:response] = 'PONG'
    render json: response, status: :ok
  end

  def auth
    response = Hash.new
    response[:response] = 'Authenticated'
    render json: response, status: :ok
    #render text: 'Authenticated', status: :ok
  end

  # PUT /assist/:id
  # Marks a person as it shown to the event
  def assist
    id = params[:id]
    # id validation
    # Handle complex id
    id_regex = /^(\d+)-?(\d*)$/
    if id =~ id_regex
      match = id_regex.match(id)
      id = match[1]
    else
      render_error 'Id inválido.'
      return
    end
    # Old only-main accepted.
    #unless id =~ /^\d+$/

    begin
      person = Person.includes(:guests, :food, :allocation).find id
    rescue
      render_error 'Registro no encontrado.'
      return
    end

    unless person.isconfirmed
      render_error "El registro de #{person.nickname} no está pagado."
      return
    end

    # Everything is alright, mark it as present if needed
    unless person.ispresent?
      person.ispresent = true
      person.save
    end
    # Don't transfer these values
    person.password = ''
    person.salt = ''
    render json: person.to_json( { :include => [:guests, :food, :allocation],
                                   :methods => [:total, :total_people_cost, :is_adult] }),
           status: :ok
  end

  # PUT food/:day/:time/:id
  def food
    day = params[:day]
    time = params[:time]
    id = params[:id]
    name = ''
    guest_id = ''
    children_modifier = ''
    unless day =~ /^[vsdl]$/
      render_error 'Error en el dia'
      return
    end
    unless time =~ /^[123]$/
      render_error 'Error en el tiempo'
      return
    end

    # Handle complex id
    id_regex = /^(\d+)-?(\d*)$/
    if id =~ id_regex
      match = id_regex.match(id)
      id = match[1]
      if match[2].length > 0
        guest_id = match[2]
        guest = Guest.find guest_id
        children_modifier = guest.is_adult ? '' : 'c'
        name = guest.nickname
      end
    else
      render_error 'Error en el Id'
      return
    end

    # All initial validations passed
    normal_field_name = "#{day}#{time}"
    child_field_name = "#{day}#{time}c"
    field_name = "#{day}#{time}#{children_modifier}"

    # Getting information from DB, and setting Foodreal if not exists
    begin
      person = Person.includes(:food).find(id)
      name = person.nickname if name == ''
      food = person.food
      # not reliable -> person.isconfirmed
      # changed to amount paid
      is_paid = (person.total - person.amount_paid) <= 0
      raise NotPaidError unless is_paid
      raise if food.nil? #gets here if the person exists, but no the food record, unlikely
      foodreal = Foodreal.find_by_person_id id
      if foodreal.nil?
        foodreal = Foodreal.create(person_id: id)
      end
    rescue NotPaidError => e
      response = Hash.new
      response[:name] = name
      response[:bought] = food[normal_field_name]
      response[:bought_child] = food[child_field_name]
      response[:used] = ''
      response[:used_child] = ''
      response[:available] = 'DEPRECATED'
      response[:foodtype] = children_modifier == 'c' ? 'Niño' : 'Adulto'
      response[:count_real] = ''
      response[:max_people_time] = ''
      response[:status] = e.message
      render json: response, status: :ok
      return
    rescue
      render nothing: true, status: :internal_server_error
      return
    end

    status = ''
    bought_to_use = food[field_name]
    used = foodreal[field_name]
    available = bought_to_use - used

    # Starts logic
    if available > 0
      # OK
      used += 1
      foodreal[field_name] = used
      foodreal.save
    else
      # Not enough food bought
      status = 'Error! Los platos solicitados ya han sido consumidos.'
    end

    currently = Foodreal.sum_for normal_field_name

    response = Hash.new
    response[:name] = name
    response[:bought] = food[normal_field_name]
    response[:bought_child] = food[child_field_name]
    response[:used] = foodreal[normal_field_name]
    response[:used_child] = foodreal[child_field_name]
    response[:available] = 'DEPRECATED'
    response[:foodtype] = children_modifier == 'c' ? 'Niño' : 'Adulto'
    response[:count_real] = currently['currently']
    response[:max_people_time] = 250
    response[:status] = status
    render json: response, status: :ok
  end

  # PUT food_correction/:day/:time/:id
  # Warning not intended for regular use, emergencies only
  # Just when accidentally double charge is made.
  def food_correction
    day = params[:day]
    time = params[:time]
    id = params[:id]
    commit = params[:commit] == 'true' ? true : false
    id_regex = /^(\d+)-?(\d*)$/
    if id =~ id_regex
      match = id_regex.match(id)
      id = match[1]
      if match[2].length > 0
        guest_id = match[2]
        guest = Guest.find guest_id
        children_modifier = guest.is_adult ? '' : 'c'
        name = guest.nickname
      else
        p = Person.find id
        name = p.full_name
      end
    else
      render_error 'Error en el Id'
      return
    end

    foodreal = Foodreal.find_by_person_id id

    # All initial validations passed
    field_name = "#{day}#{time}#{children_modifier}"

    used = foodreal[field_name]
    new = used - 1
    if used == 0
      new = 0
      commit = false
    end
    if commit
      foodreal[field_name] = new
      foodreal.save
    end

    response = Hash.new
    response[:id] = id
    response[:name] = name
    response[:field] = field_name
    response[:field_cur] = used
    response[:field_new] = new
    response[:commited] = commit
    render json: response, status: :ok
  end

  # GET cancel/:hash
  def cancel
    email_hash = params[:hash]
    people = Person.find_by_email_hashed(email_hash)
    if people.length < 1
      render nothing: true, status: :not_found
      return
    end
    person = people[0]
    unless person.iscancelled
      person.iscancelled = true
      person.save
    end

    response = Hash.new
    response[:id] = person.id
    response[:is_cancelled] = person.iscancelled
    render json: response, status: :ok
  end

  # GET make_admin/:id(/:commit)
  def make_admin
    id = params[:id]
    commit = params[:commit] == 'true' ? true : false

    begin
      person = Person.lock(true).find id
      current = person.isadmin
      #if commit and (not person.isadmin)
      if commit
        person.isadmin = (not current)
        person.save
      else
        commit = false
      end
    rescue
      render_error 'Persona no encontrada'
      return
    end

    response = Hash.new
    response[:id] = id
    response[:name] = person.full_name
    response[:email] = person.email
    response[:old_value] = current
    response[:isadmin] = person.isadmin
    response[:commited] = commit
    render json: response, status: :ok
  end

  private
    def render_error(error)
      render text: error, status: :bad_request
    end
end
