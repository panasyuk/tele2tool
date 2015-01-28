$ ->
  $('#btn-download-xls').on 'click', (e) ->
    e.preventDefault()
    $('form#filter input#format').val('xls')
    $('form#filter').submit()
    $('form#filter input#format').val('html')

  cb = (start, end, label) ->
    $("#reportrange span").html start.format("DD.MM.YYYY") + " - " + end.format("DD.MM.YYYY")

  rangePickerOptions =
    startDate: moment().subtract(29, "days")
    endDate: moment()
    opens: "left"
    format: "DD.MM.YYYY"
    locale:
      applyLabel: "Применить"
      cancelLabel: "Отмена"
      fromLabel: "С"
      toLabel: "По"
      customRangeLabel: "выбранный интервал"
    ranges:
      "последние 7 дней": [
        moment().subtract(6, "days")
        moment()
      ]
      "последние 30 дней": [
        moment().subtract(29, "days")
        moment()
      ]
      "этот месяц": [
        moment().startOf("month")
        moment().endOf("month")
      ]
      "прошлый месяц": [
        moment().subtract(1, "month").startOf("month")
        moment().subtract(1, "month").endOf("month")
      ]

  $("#reportrange span").html moment().subtract(29, "days").format("DD.MM.YYYY") + " - " + moment().format("DD.MM.YYYY")
  $("#reportrange").daterangepicker rangePickerOptions, cb
