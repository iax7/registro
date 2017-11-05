class ReportsController < ApplicationController
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'

  def registros
    validate_rights
    people = Person.all.order :lastname
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

  def gafete_bulk
    is_downloaded = true
    people = []
    Person.order(:id).includes(:guests).map do |p|
      people << { id: p.id,
        nickname: p.nickname,
        church: p.church,
        city: p.city,
        is_adult: p.is_adult,
        is_male: p.ismale }
      if p.guests.length > 0
         p.guests.map do |g|
           people << { id: "#{p.id}-#{g.id}",
             nickname: g.nickname,
             church: p.church,
             city: p.city,
             is_adult: g.is_adult,
             is_male: g.ismale }
         end
      end
    end
    render_gafete_bulk(people, is_downloaded)
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
        end
      end

      send_data report.generate,
                filename: "#{report_name}.pdf",
                type: 'application/pdf',
                disposition: 'inline'
    end

    def render_gafete(person, is_attachment)
      def generate_page(report,
                        id,
                        nickname,
                        church,
                        city,
                        is_adult,
                        is_male)
        report.start_new_page
        report.page.item(:txtIglesia).value(church)
        report.page.item(:txtNombre).value(nickname)
        report.page.item(:txtCiudad).value(city)
        report.page.item(:txtCodigo).value(id)
        report.page.item(:imgCodigo).src(get_barcode(id))
        report.page.item(:txtNino).value( get_agekind_text(is_adult,is_male) )
      end

      report_name = 'gafete'
      path = File.join(Rails.root, 'app', 'reports', "#{report_name}.tlf")
      report = ThinReports::Report.new layout: path

      generate_page report,
                    person.id,
                    person.nickname,
                    person.church,
                    person.city,
                    person.is_adult,
                    person.ismale
      person.guests.each do |guest|
        generate_page report,
                      "#{person.id}-#{guest.id}",
                      guest.nickname,
                      person.church, person.city,
                      guest.is_adult,
                      guest.ismale
      end

      dispo = is_attachment ? 'attachment' : 'inline'
      send_data report.generate,
                filename: "#{report_name}.pdf",
                type: 'application/pdf',
                disposition: dispo
    end

    def render_gafete_bulk(people, is_attachment)
      report_name = 'gafete_bulk'
      path = File.join(Rails.root, 'app', 'reports', "#{report_name}.tlf")
      report = ThinReports::Report.new layout: path

      people.in_groups_of(4) do |group|
        report.start_new_page
        group.each_with_index do |val,index|
          unless val.nil?
            report.page.item("txtIglesia#{index+1}").value( val[:church] )
            report.page.item("txtNombre#{index+1}" ).value( val[:nickname])
            report.page.item("txtCiudad#{index+1}" ).value( val[:city])
            report.page.item("txtCodigo#{index+1}" ).value( val[:id])
            report.page.item("imgCodigo#{index+1}" ).src(get_barcode(val[:id]))
            report.page.item("txtNino#{index+1}"   ).value(get_agekind_text(val[:is_adult],val[:is_male]))
          end
        end
      end

      dispo = is_attachment ? 'attachment' : 'inline'
      send_data report.generate,
                filename: "#{report_name}.pdf",
                type: 'application/pdf',
                disposition: dispo
    end

    def get_barcode(id)
      barcode = Barby::Code128B.new(id)
      blob = Barby::PngOutputter.new(barcode).to_png #Raw PNG data
      StringIO.new(blob)
    end
    def get_agekind_text(is_adult, is_male)
      if is_adult
        ''
      else
        is_male ? 'Niño' : 'Niña'
      end
    end
end