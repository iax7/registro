class ConfigsController < ApplicationController
  before_action :require_admin

  # GET /configs
  # GET /configs.json
  def index
  end

  # GET /configs/1
  # GET /configs/1.json
  def show
    @data = YAML.load_file 'config/app_config.yml'
  end

  # GET /configs/new
  def new
  end

  # GET /configs/1/edit
  def edit
    @data = YAML.load_file 'config/app_config.yml'
  end

  # POST /configs
  # POST /configs.json
  def create
  end

  # PATCH/PUT /configs/1
  # PATCH/PUT /configs/1.json
  def update
    #data["Name"] = ABC
    #File.open("path/to/yml_file.yml", 'w') { |f| YAML.dump(data, f) }
  end

  # DELETE /configs/1
  # DELETE /configs/1.json
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def config_params
    end
end
