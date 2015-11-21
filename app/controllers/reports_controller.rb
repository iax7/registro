class ReportsController < ApplicationController

  def registros
    validate_rights
    people = Person.all
    render_people_list(people)
  end

  def gafete
    id = session_id
    return unless id.is_a? Numeric

    is_downloaded = true
    if params.has_key? :id
      id = is_admin ? params[:id] : session_id
    end
    if params.has_key? :inline
      is_downloaded = false
    end
    person = Person.find(id)
    render_gafete(person, is_downloaded)
  end

  private
    def validate_rights
      unless is_admin
        redirect_to welcome_index_url
      end
    end

    def render_people_list(people)
      report_name = 'registros'
      report_title = 'Relación de Inscripciones'

      path = File.join(Rails.root, 'app', 'reports', "#{report_name}.tlf")
      report = ThinReports::Report.new layout: path

      report.layout.config.list :default do
        use_stores row_count: 0
      end

      report.start_new_page
      report.page.item(:txtTitle).value(report_title)
      report.page.item(:txtFecha).value(Time.now)

      people.each do |person|
        report.page.list(:default) do |row|
          row.add_row txtId: person.id,
                      txtNombre: "#{person.name} #{person.lastname}",
                      txtEmail: person.email,
                      txtInv: person.guests.length,
                      txtHos1: person.allocation.total_nights,
                      txtAl: person.food.total_meals,
                      txtTotal: person.total,
                      txtPagado: 0
          #row.item(:txtId).style(:color, 'red') unless person.isconfirmed
          row.store.row_count += 1
        end
      end

      send_data report.generate,
                filename: "#{report_name}.pdf",
                type: 'application/pdf',
                disposition: 'inline'
    end

    def render_gafete(person, is_attachment)
      def generate_page(report, id, nickname, church, city, is_adult)
        report.start_new_page
        report.page.item(:txtIglesia).value(church)
        report.page.item(:txtNombre).value(nickname)
        report.page.item(:txtCiudad).value(city)

        report.page.item(:txtCodigo).value(id)
        barcode = Barby::Code128B.new(id)
        blob = Barby::PngOutputter.new(barcode).to_png #Raw PNG data
        report.page.item(:imgCodigo).src(StringIO.new(blob))

        txtNino = is_adult ? '' : 'Niño'
        report.page.item(:txtNino).value(txtNino)
      end
      require 'barby'
      require 'barby/barcode/code_128'
      require 'barby/outputter/png_outputter'

      report_name = 'gafete'

      path = File.join(Rails.root, 'app', 'reports', "#{report_name}.tlf")
      report = ThinReports::Report.new layout: path

      generate_page report, person.id, person.nickname, person.church, person.city, person.is_adult
      person.guests.each do |guest|
        generate_page report, "#{person.id}-#{guest.id}", guest.nickname, person.church, person.city, guest.is_adult
      end

      dispo = is_attachment ? 'attachment' : 'inline'
      send_data report.generate,
                filename: "#{report_name}.pdf",
                type: 'application/pdf',
                disposition: dispo
    end
end