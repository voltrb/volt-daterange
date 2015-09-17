module Daterange
  class MainController < Volt::ModelController

    def format_str
      attrs.format_str || 'MM-DD-YYYY'
    end

    def index_ready
      callback = proc { |start_date, end_date| set_date(start_date, end_date) }
      `
      var opts = {
        ranges: {
          'Today': [moment(), moment()],
          'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
          'Last 7 Days': [moment().subtract(6, 'days'), moment()],
          'Last 30 Days': [moment().subtract(29, 'days'), moment()],
          'This Month': [moment().startOf('month'), moment().endOf('month')],
          'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        }
      };
      `
      # You can specify an integer to limit the number of days you can select
      # at once.
      if attrs.limit_days
        `opts.dateLimit = {
          days: #{attrs.limit_days.to_i}
        };`
      end

      @picker = `$(#{first_element}).daterangepicker(opts, #{callback})`

      puts "a"
      if attrs.start_date
        start_date = `moment(#{attrs.start_date}, #{format_str})`
      else
        start_date = `moment().subtract(29, 'days')`
      end

      puts "b"

      if attrs.end_date
        end_date = `moment(#{attrs.end_date}, #{format_str})`
      else
        end_date = `moment()`
      end

      puts "c"

      set_date(start_date, end_date)

      puts "d"

      @start_comp = proc do
        val = attrs.start_date
        picker = @picker
        if val
          `
          if (picker.setStartDate) {
            var date = moment(val);
            if (date.isValid()) {
              console.log('set start');
              picker.setStartDate(date);
            }
          }
          `
        end
      end.watch!

      @end_comp = proc do
        val = attrs.end_date
        picker = @picker
        if val
          puts "Try Update"
          `
          if (picker.setEndDate) {
            var date = moment(val);
            if (date.isValid()) {
              console.log('set end');
              picker.setEndDate(date);
            }
          }
          `
        end
      end.watch!


    end

    def picker
      # Get the picker obj so we can set on it
      return `$(#{first_element}).data('daterangepicker')`
    end

    def before_index_remove
      @start_comp.stop
      @end_comp.stop
    end

    def set_date(start_date, end_date)
      `$(#{first_element}).find('span').html(start_date.format(#{format_str}) + ' - ' + end_date.format(#{format_str})); `

      attrs.start_date = `start_date.format(#{format_str})`
      attrs.end_date = `end_date.format(#{format_str})`
    end
  end
end
