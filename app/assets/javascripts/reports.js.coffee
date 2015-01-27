# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@downloadXLS = ()->
  $('form#filter input#format').val('xls')
  $('form#filter').submit()
  $('form#filter input#format').val('html')

$ ->
  datepickerFormat = {dateFormat: 'yy-mm-dd'}
  $('#date_to').datepicker(datepickerFormat)
  $('#date_from').datepicker(datepickerFormat)
  $('#btn-download-xls').on('click', downloadXLS)
