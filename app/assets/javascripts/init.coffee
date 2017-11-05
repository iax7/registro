# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.App ||= {}

App.init = ->
  #$('[data-toggle="tooltip"]').tooltip();
  #Bootstrap Tooltip fancy view
  $("a, span, i, div").tooltip()

$(document).on "turbolinks:load", ->
  App.init()