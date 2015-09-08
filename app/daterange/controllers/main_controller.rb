module Daterange
  class MainController < Volt::ModelController

    def index_ready

    # function cb(start, end) {
    #     $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    # }
    # cb(moment().subtract(29, 'days'), moment());

    `
    $(#{first_element}).daterangepicker({
        ranges: {
           'Today': [moment(), moment()],
           'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
           'Last 7 Days': [moment().subtract(6, 'days'), moment()],
           'Last 30 Days': [moment().subtract(29, 'days'), moment()],
           'This Month': [moment().startOf('month'), moment().endOf('month')],
           'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        }
    }, #{method(:cb).to_proc});
    `
    end

    def set_date(start, end)

    end
  end
end
