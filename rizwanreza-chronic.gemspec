require "rubygems"
SPEC = Gem::Specification.new do |s|
  s.name = 'rizwanreza-chronic'
  s.version = '0.0.1'
  s.authors = ['Rizwan Reza', 'Tom Preston-Werner']
  s.email = 'contact@rizwanreza.com'
  s.homepage = 'http://github.com/rizwanreza/chronic'
  s.platform = Gem::Platform::RUBY
  s.summary = "A natural language date parser with timezone support"
  s.description = <<-EOF
      This is a gem-fork of Chronic currently being developed to support 1.9.2
      100%. The tests will also be migrated to RSpec.
EOF
  # Explicitly list all files because Dir[] is incompatible with safelevel 3
  # Just run irb >> Dir["{lib,test}/**/*"] to get the newest array of files
  s.files = ["lib/chronic", "lib/chronic/blunt.rb", "lib/chronic/chronic.rb", "lib/chronic/grabber.rb", "lib/chronic/handlers.rb", "lib/chronic/ordinal.rb", "lib/chronic/pointer.rb", "lib/chronic/repeater.rb", "lib/chronic/repeaters", "lib/chronic/repeaters/repeater_day.rb", "lib/chronic/repeaters/repeater_day_name.rb", "lib/chronic/repeaters/repeater_day_portion.rb", "lib/chronic/repeaters/repeater_decade.rb", "lib/chronic/repeaters/repeater_fortnight.rb", "lib/chronic/repeaters/repeater_hour.rb", "lib/chronic/repeaters/repeater_minute.rb", "lib/chronic/repeaters/repeater_month.rb", "lib/chronic/repeaters/repeater_month_name.rb", "lib/chronic/repeaters/repeater_season.rb", "lib/chronic/repeaters/repeater_season_name.rb", "lib/chronic/repeaters/repeater_second.rb", "lib/chronic/repeaters/repeater_time.rb", "lib/chronic/repeaters/repeater_week.rb", "lib/chronic/repeaters/repeater_weekday.rb", "lib/chronic/repeaters/repeater_weekend.rb", "lib/chronic/repeaters/repeater_year.rb", "lib/chronic/scalar.rb", "lib/chronic/separator.rb", "lib/chronic/time_zone.rb", "lib/chronic.rb", "lib/core_ext", "lib/core_ext/object.rb", "lib/core_ext/time.rb", "lib/numerizer", "lib/numerizer/numerizer.rb", "test/test_Chronic.rb", "test/test_DaylightSavings.rb", "test/test_Handler.rb", "test/test_Numerizer.rb", "test/test_parsing.rb", "test/test_RepeaterDayName.rb", "test/test_RepeaterDecade.rb", "test/test_RepeaterFortnight.rb", "test/test_RepeaterHour.rb", "test/test_RepeaterMinute.rb", "test/test_RepeaterMonth.rb", "test/test_RepeaterMonthName.rb", "test/test_RepeaterSeason.rb", "test/test_RepeaterTime.rb", "test/test_RepeaterWeek.rb", "test/test_RepeaterWeekday.rb", "test/test_RepeaterWeekend.rb", "test/test_RepeaterYear.rb", "test/test_Span.rb", "test/test_Time.rb", "test/test_Token.rb"]
  s.require_path = "lib"
  # s.autorequire = "chronic"
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options << '--main' << 'README.rdoc'
  s.rubyforge_project = 'rake'
end
