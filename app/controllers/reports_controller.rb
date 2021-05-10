# frozen_string_literal: true

require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

# Uses ThinReports to create the Badges
class ReportsController < ApplicationController
  before_action :confirm_logged_in
  before_action :require_admin

  def badge
    is_downloaded = !params.key?(:inline)

    if params.key? :id
      # id = is_admin ? params[:id] : session_id
      id = params[:id]
    end

    guests = []
    Registry.includes(:user,
                      :guests).order('guests.id').where(event_id: Event.current.id, id: id).first.guests.each do |guest|
      guests << digest_guest_data(guest)
    end

    send_data render_badge(guests),
              filename: 'badge.pdf',
              type: 'application/pdf',
              disposition: view_mode(is_downloaded)
  end

  def badge_bulk
    is_downloaded = true

    guests = []
    Guest.order(:id).includes(:registry).where(registries: { event_id: Event.current.id }).find_each do |guest|
      guests << digest_guest_data(guest)
    end

    send_data render_badge_bulk(guests),
              filename: 'badge_bulk.pdf',
              type: 'application/pdf',
              disposition: view_mode(is_downloaded)
  end

  private

  # @param is_downloaded [Boolean]
  # @return [String (frozen)]
  def view_mode(is_downloaded)
    is_downloaded ? 'attachment' : 'inline'
  end

  def render_badge(guests)
    report_file = 'badge'
    report_path = File.join(Rails.root, 'app', 'reports', "#{report_file}.tlf")
    report = Thinreports::Report.new layout: report_path

    guests.each do |guest|
      report.start_new_page
      report.page.item(:txtYear).value guest[:year]
      report.page.item(:txtChurch).value guest[:church]
      report.page.item(:txtName).value guest[:nickname]
      report.page.item(:txtCity).value guest[:city]
      report.page.item(:txtCode).value guest[:id]
      report.page.item(:imgCode).src(get_barcode_png(guest[:id]))
      report.page.item(:txtChild).value guest[:child_text]
    end
    report.generate
  end

  def render_badge_bulk(guests)
    report_file = 'badge_bulk'
    report_path = File.join(Rails.root, 'app', 'reports', "#{report_file}.tlf")
    report = Thinreports::Report.new layout: report_path

    guests.in_groups_of(4) do |group|
      report.start_new_page
      group.each_with_index do |val, index|
        next if val.nil?

        report.page.item("txtYear#{index + 1}").value val[:year]
        report.page.item("txtChurch#{index + 1}").value val[:church]
        report.page.item("txtName#{index + 1}").value val[:nickname]
        report.page.item("txtCity#{index + 1}").value val[:city]
        report.page.item("txtCode#{index + 1}").value val[:id]
        report.page.item("imgCode#{index + 1}").src(get_barcode_png(val[:id]))
        report.page.item("txtChild#{index + 1}").value val[:child_text]
      end
    end
    report.generate
  end

  def get_barcode_png(id)
    barcode = Barby::Code128B.new(id)
    blob = Barby::PngOutputter.new(barcode).to_png # Raw PNG data
    StringIO.new(blob)
  end

  def digest_guest_data(guest)
    {
      id: guest.id,
      nickname: guest.nick,
      church: guest.registry.user.city,
      city: "#{guest.registry.user.state}, #{guest.registry.user.country}",
      child_text: get_agekind_text(guest.adult?, guest.is_male),
      year: Event.current.name
    }
  end

  def get_agekind_text(is_adult, is_male)
    return '' if is_adult

    is_male ? 'Niño' : 'Niña'
  end
end
