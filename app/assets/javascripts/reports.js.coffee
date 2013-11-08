# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  datepickerFormat = {dateFormat: 'yy-mm-dd'}
  $('#date_to').datepicker(datepickerFormat)
  $('#date_from').datepicker(datepickerFormat)