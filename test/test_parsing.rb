$:.unshift(File.expand_path('../../lib', __FILE__))
require 'chronic'
require 'test/unit'

class TestParsing < Test::Unit::TestCase
	# Wed Aug 16 14:00:00 UTC 2006
	TIME_2006_08_16_14_00_00 = Time.local(2006, 8, 16, 14, 0, 0, 0)

	def setup
		@time_2006_08_16_14_00_00 = TIME_2006_08_16_14_00_00
	end

	def test_parse_guess_dates
		# rm_sd

		time = parse_now("may 27")
		assert_equal Time.local(2007, 5, 27, 12), time

		time = parse_now("may 28", :context => :past)
		assert_equal Time.local(2006, 5, 28, 12), time

		time = parse_now("may 28 5pm", :context => :past)
		assert_equal Time.local(2006, 5, 28, 17), time

		time = parse_now("may 28 at 5pm", :context => :past)
		assert_equal Time.local(2006, 5, 28, 17), time

		time = parse_now("may 28 at 5:32.19pm", :context => :past)
		assert_equal Time.local(2006, 5, 28, 17, 32, 19), time

		# rm_sd_on

		time = parse_now("5pm on may 28")
		assert_equal Time.local(2007, 5, 28, 17), time

		time = parse_now("5pm may 28")
		assert_equal Time.local(2007, 5, 28, 17), time

		time = parse_now("5 on may 28", :ambiguous_time_range => :none)
		assert_equal Time.local(2007, 5, 28, 05), time

		# rm_od

		time = parse_now("may 27th")
		assert_equal Time.local(2007, 5, 27, 12), time

		time = parse_now("may 27th", :context => :past)
		assert_equal Time.local(2006, 5, 27, 12), time

		time = parse_now("may 27th 5:00 pm", :context => :past)
		assert_equal Time.local(2006, 5, 27, 17), time

		time = parse_now("may 27th at 5pm", :context => :past)
		assert_equal Time.local(2006, 5, 27, 17), time

		time = parse_now("may 27th at 5", :ambiguous_time_range => :none)
		assert_equal Time.local(2007, 5, 27, 5), time

		# rm_od_sy

		time = parse_now("may 27th 2007")
		assert_equal Time.local(2007, 5, 27, 12), time

		# rm_od_on

		time = parse_now("5:00 pm may 27th", :context => :past)
		assert_equal Time.local(2006, 5, 27, 17), time

		time = parse_now("5pm on may 27th", :context => :past)
		assert_equal Time.local(2006, 5, 27, 17), time

		time = parse_now("5 on may 27th", :ambiguous_time_range => :none)
		assert_equal Time.local(2007, 5, 27, 5), time

		# rm_sy

		time = parse_now("June 1979")
		assert_equal Time.local(1979, 6, 16, 0), time

		time = parse_now("dec 79")
		assert_equal Time.local(1979, 12, 16, 12), time

		# rm_sd_sy

		time = parse_now("jan 3 2010")
		assert_equal Time.local(2010, 1, 3, 12), time

		time = parse_now("jan 3 2010 midnight")
		assert_equal Time.local(2010, 1, 4, 0), time

		time = parse_now("jan 3 2010 at midnight")
		assert_equal Time.local(2010, 1, 4, 0), time

		time = parse_now("jan 3 2010 at 4", :ambiguous_time_range => :none)
		assert_equal Time.local(2010, 1, 3, 4), time

		#time = parse_now("January 12, '00")
		#assert_equal Time.local(2000, 1, 12, 12), time

		time = parse_now("may 27, 1979")
		assert_equal Time.local(1979, 5, 27, 12), time

		time = parse_now("may 27 79")
		assert_equal Time.local(1979, 5, 27, 12), time

		time = parse_now("may 27 79 4:30")
		assert_equal Time.local(1979, 5, 27, 16, 30), time

		time = parse_now("may 27 79 at 4:30", :ambiguous_time_range => :none)
		assert_equal Time.local(1979, 5, 27, 4, 30), time

		# sd_rm_sy

		time = parse_now("3 jan 2010")
		assert_equal Time.local(2010, 1, 3, 12), time

		time = parse_now("3 jan 2010 4pm")
		assert_equal Time.local(2010, 1, 3, 16), time

		time = parse_now("27 Oct 2006 7:30pm")
		assert_equal Time.local(2006, 10, 27, 19, 30), time

		# sm_sd_sy

		time = parse_now("5/27/1979")
		assert_equal Time.local(1979, 5, 27, 12), time

		time = parse_now("5/27/1979 4am")
		assert_equal Time.local(1979, 5, 27, 4), time

		# sd_sm_sy

		time = parse_now("27/5/1979")
		assert_equal Time.local(1979, 5, 27, 12), time

		time = parse_now("27/5/1979 @ 0700")
		assert_equal Time.local(1979, 5, 27, 7), time

		# sm_sy

		time = parse_now("05/06")
		assert_equal Time.local(2006, 5, 16, 12), time

		time = parse_now("12/06")
		assert_equal Time.local(2006, 12, 16, 12), time

		time = parse_now("13/06")
		assert_equal nil, time

		# sy_sm_sd

		time = parse_now("2000-1-1")
		assert_equal Time.local(2000, 1, 1, 12), time

		time = parse_now("2006-08-20")
		assert_equal Time.local(2006, 8, 20, 12), time

		time = parse_now("2006-08-20 7pm")
		assert_equal Time.local(2006, 8, 20, 19), time

		time = parse_now("2006-08-20 03:00")
		assert_equal Time.local(2006, 8, 20, 3), time

		time = parse_now("2006-08-20 03:30:30")
		assert_equal Time.local(2006, 8, 20, 3, 30, 30), time

		time = parse_now("2006-08-20 15:30:30")
		assert_equal Time.local(2006, 8, 20, 15, 30, 30), time

		time = parse_now("2006-08-20 15:30.30")
		assert_equal Time.local(2006, 8, 20, 15, 30, 30), time

		# rdn_rm_rd_rt_rtz_ry

		time = parse_now("Mon Apr 02 17:00:00 PDT 2007")
		assert_equal 1175558400, time.to_i

		now = Time.now
		time = parse_now(now.to_s)
		assert_equal now.to_s, time.to_s

		# rm_sd_rt

		time = parse_now("jan 5 13:00")
		assert_equal Time.local(2007, 1, 5, 13), time

		time = parse_now("40 may")
		assert_equal nil, time

		time = parse_now("40 may 27")
		assert_equal nil, time

		time = parse_now("1800-08-20")
    assert_equal Time.local(1800, 8, 20, 12), time
	end

	def test_parse_guess_r
		time = parse_now("friday")
		assert_equal Time.local(2006, 8, 18, 12), time

		time = parse_now("tue")
		assert_equal Time.local(2006, 8, 22, 12), time

		time = parse_now("5")
		assert_equal Time.local(2006, 8, 16, 17), time

		time = Chronic.parse("5", :now => Time.local(2006, 8, 16, 3, 0, 0, 0), :ambiguous_time_range => :none)
		assert_equal Time.local(2006, 8, 16, 5), time

		time = parse_now("13:00")
		assert_equal Time.local(2006, 8, 17, 13), time

		time = parse_now("13:45")
		assert_equal Time.local(2006, 8, 17, 13, 45), time

		time = parse_now("november")
		assert_equal Time.local(2006, 11, 16), time
	end

	def test_parse_guess_rr
		time = parse_now("friday 13:00")
		assert_equal Time.local(2006, 8, 18, 13), time

		time = parse_now("monday 4:00")
		assert_equal Time.local(2006, 8, 21, 16), time

		time = parse_now("sat 4:00", :ambiguous_time_range => :none)
		assert_equal Time.local(2006, 8, 19, 4), time

		time = parse_now("sunday 4:20", :ambiguous_time_range => :none)
		assert_equal Time.local(2006, 8, 20, 4, 20), time

		time = parse_now("4 pm")
		assert_equal Time.local(2006, 8, 16, 16), time

		time = parse_now("4 am", :ambiguous_time_range => :none)
		assert_equal Time.local(2006, 8, 16, 4), time

		time = parse_now("12 pm")
		assert_equal Time.local(2006, 8, 16, 12), time

		time = parse_now("12:01 pm")
		assert_equal Time.local(2006, 8, 16, 12, 1), time

		time = parse_now("12:01 am")
		assert_equal Time.local(2006, 8, 16, 0, 1), time

		time = parse_now("12 am")
		assert_equal Time.local(2006, 8, 16), time

		time = parse_now("4:00 in the morning")
		assert_equal Time.local(2006, 8, 16, 4), time

		time = parse_now("november 4")
		assert_equal Time.local(2006, 11, 4, 12), time

		time = parse_now("aug 24")
		assert_equal Time.local(2006, 8, 24, 12), time
	end

	def test_parse_guess_rrr
		time = parse_now("friday 1 pm")
		assert_equal Time.local(2006, 8, 18, 13), time

		time = parse_now("friday 11 at night")
		assert_equal Time.local(2006, 8, 18, 23), time

		time = parse_now("friday 11 in the evening")
		assert_equal Time.local(2006, 8, 18, 23), time

		time = parse_now("sunday 6am")
		assert_equal Time.local(2006, 8, 20, 6), time

		time = parse_now("friday evening at 7")
		assert_equal Time.local(2006, 8, 18, 19), time
	end

	def test_parse_guess_gr
		# year

		time = parse_now("this year")
		assert_equal Time.local(2006, 10, 24, 12), time

		time = parse_now("this year", :context => :past)
		assert_equal Time.local(2006, 4, 24, 12), time

		# month

		time = parse_now("this month")
		assert_equal Time.local(2006, 8, 24, 12), time

		time = parse_now("this month", :context => :past)
		assert_equal Time.local(2006, 8, 8, 12), time

		time = Chronic.parse("next month", :now => Time.local(2006, 11, 15))
		assert_equal Time.local(2006, 12, 16, 12), time

		# month name

		time = parse_now("last november")
		assert_equal Time.local(2005, 11, 16), time

		# fortnight

		time = parse_now("this fortnight")
		assert_equal Time.local(2006, 8, 21, 19, 30), time

		time = parse_now("this fortnight", :context => :past)
		assert_equal Time.local(2006, 8, 14, 19), time

		# week

		time = parse_now("this week")
		assert_equal Time.local(2006, 8, 18, 7, 30), time

		time = parse_now("this week", :context => :past)
		assert_equal Time.local(2006, 8, 14, 19), time

		# weekend

		time = parse_now("this weekend")
		assert_equal Time.local(2006, 8, 20), time

		time = parse_now("this weekend", :context => :past)
		assert_equal Time.local(2006, 8, 13), time

		time = parse_now("last weekend")
		assert_equal Time.local(2006, 8, 13), time

		# day

		time = parse_now("this day")
		assert_equal Time.local(2006, 8, 16, 19, 30), time

		time = parse_now("this day", :context => :past)
		assert_equal Time.local(2006, 8, 16, 7), time

		time = parse_now("today")
		assert_equal Time.local(2006, 8, 16, 19, 30), time

		time = parse_now("yesterday")
		assert_equal Time.local(2006, 8, 15, 12), time

		time = parse_now("tomorrow")
		assert_equal Time.local(2006, 8, 17, 12), time

		# day name

		time = parse_now("this tuesday")
		assert_equal Time.local(2006, 8, 22, 12), time

		time = parse_now("next tuesday")
		assert_equal Time.local(2006, 8, 22, 12), time

		time = parse_now("last tuesday")
		assert_equal Time.local(2006, 8, 15, 12), time

		time = parse_now("this wed")
		assert_equal Time.local(2006, 8, 23, 12), time

		time = parse_now("next wed")
		assert_equal Time.local(2006, 8, 23, 12), time

		time = parse_now("last wed")
		assert_equal Time.local(2006, 8, 9, 12), time

		# day portion

		time = parse_now("this morning")
		assert_equal Time.local(2006, 8, 16, 9), time

		time = parse_now("tonight")
		assert_equal Time.local(2006, 8, 16, 22), time

		# minute

		time = parse_now("next minute")
		assert_equal Time.local(2006, 8, 16, 14, 1, 30), time

		# second

		time = parse_now("this second")
		assert_equal Time.local(2006, 8, 16, 14), time

		time = parse_now("this second", :context => :past)
		assert_equal Time.local(2006, 8, 16, 14), time

		time = parse_now("next second")
		assert_equal Time.local(2006, 8, 16, 14, 0, 1), time

		time = parse_now("last second")
		assert_equal Time.local(2006, 8, 16, 13, 59, 59), time
	end

	def test_parse_guess_grr
		time = parse_now("yesterday at 4:00")
		assert_equal Time.local(2006, 8, 15, 16), time

		time = parse_now("today at 9:00")
		assert_equal Time.local(2006, 8, 16, 9), time

		time = parse_now("today at 2100")
		assert_equal Time.local(2006, 8, 16, 21), time

		time = parse_now("this day at 0900")
		assert_equal Time.local(2006, 8, 16, 9), time

		time = parse_now("tomorrow at 0900")
		assert_equal Time.local(2006, 8, 17, 9), time

		time = parse_now("yesterday at 4:00", :ambiguous_time_range => :none)
		assert_equal Time.local(2006, 8, 15, 4), time

		time = parse_now("last friday at 4:00")
		assert_equal Time.local(2006, 8, 11, 16), time

		time = parse_now("next wed 4:00")
		assert_equal Time.local(2006, 8, 23, 16), time

		time = parse_now("yesterday afternoon")
		assert_equal Time.local(2006, 8, 15, 15), time

		time = parse_now("last week tuesday")
		assert_equal Time.local(2006, 8, 8, 12), time

		time = parse_now("tonight at 7")
		assert_equal Time.local(2006, 8, 16, 19), time

		time = parse_now("tonight 7")
		assert_equal Time.local(2006, 8, 16, 19), time

		time = parse_now("7 tonight")
		assert_equal Time.local(2006, 8, 16, 19), time
	end

	def test_parse_guess_grrr
		time = parse_now("today at 6:00pm")
		assert_equal Time.local(2006, 8, 16, 18), time

		time = parse_now("today at 6:00am")
		assert_equal Time.local(2006, 8, 16, 6), time

		time = parse_now("this day 1800")
		assert_equal Time.local(2006, 8, 16, 18), time

		time = parse_now("yesterday at 4:00pm")
		assert_equal Time.local(2006, 8, 15, 16), time

		time = parse_now("tomorrow evening at 7")
		assert_equal Time.local(2006, 8, 17, 19), time

		time = parse_now("tomorrow morning at 5:30")
		assert_equal Time.local(2006, 8, 17, 5, 30), time

		time = parse_now("next monday at 12:01 am")
		assert_equal Time.local(2006, 8, 21, 00, 1), time

		time = parse_now("next monday at 12:01 pm")
		assert_equal Time.local(2006, 8, 21, 12, 1), time
	end

	def test_parse_guess_rgr
		time = parse_now("afternoon yesterday")
		assert_equal Time.local(2006, 8, 15, 15), time

		time = parse_now("tuesday last week")
		assert_equal Time.local(2006, 8, 8, 12), time
	end

	def test_parse_guess_rrgr
		time = parse_now("5pm tomorrow")
		assert_equal Time.local(2006, 8, 17, 17), time
	end

	def test_parse_guess_s_r_p
		# past

		time = parse_now("3 years ago")
		assert_equal Time.local(2003, 8, 16, 14), time

		time = parse_now("1 month ago")
		assert_equal Time.local(2006, 7, 16, 14), time

		time = parse_now("1 fortnight ago")
		assert_equal Time.local(2006, 8, 2, 14), time

		time = parse_now("2 fortnights ago")
		assert_equal Time.local(2006, 7, 19, 14), time

		time = parse_now("3 weeks ago")
		assert_equal Time.local(2006, 7, 26, 14), time

		time = parse_now("2 weekends ago")
		assert_equal Time.local(2006, 8, 5), time

		time = parse_now("3 days ago")
		assert_equal Time.local(2006, 8, 13, 14), time

		#time = parse_now("1 monday ago")
		#assert_equal Time.local(2006, 8, 14, 12), time

		time = parse_now("5 mornings ago")
		assert_equal Time.local(2006, 8, 12, 9), time

		time = parse_now("7 hours ago")
		assert_equal Time.local(2006, 8, 16, 7), time

		time = parse_now("3 minutes ago")
		assert_equal Time.local(2006, 8, 16, 13, 57), time

		time = parse_now("20 seconds before now")
		assert_equal Time.local(2006, 8, 16, 13, 59, 40), time

		# future

		time = parse_now("3 years from now")
		assert_equal Time.local(2009, 8, 16, 14, 0, 0), time

		time = parse_now("6 months hence")
		assert_equal Time.local(2007, 2, 16, 14), time

		time = parse_now("3 fortnights hence")
		assert_equal Time.local(2006, 9, 27, 14), time

		time = parse_now("1 week from now")
		assert_equal Time.local(2006, 8, 23, 14, 0, 0), time

		time = parse_now("1 weekend from now")
		assert_equal Time.local(2006, 8, 19), time

		time = parse_now("2 weekends from now")
		assert_equal Time.local(2006, 8, 26), time

		time = parse_now("1 day hence")
		assert_equal Time.local(2006, 8, 17, 14), time

		time = parse_now("5 mornings hence")
		assert_equal Time.local(2006, 8, 21, 9), time

		time = parse_now("1 hour from now")
		assert_equal Time.local(2006, 8, 16, 15), time

		time = parse_now("20 minutes hence")
		assert_equal Time.local(2006, 8, 16, 14, 20), time

		time = parse_now("20 seconds from now")
		assert_equal Time.local(2006, 8, 16, 14, 0, 20), time

		time = Chronic.parse("2 months ago", :now => Time.parse("2007-03-07 23:30"))
		assert_equal Time.local(2007, 1, 7, 23, 30), time
	end

	def test_parse_guess_p_s_r
		time = parse_now("in 3 hours")
		assert_equal Time.local(2006, 8, 16, 17), time
	end

	def test_parse_guess_s_r_p_a
		# past

		time = parse_now("3 years ago tomorrow")
		assert_equal Time.local(2003, 8, 17, 12), time

		time = parse_now("3 years ago this friday")
		assert_equal Time.local(2003, 8, 18, 12), time

		time = parse_now("3 months ago saturday at 5:00 pm")
		assert_equal Time.local(2006, 5, 19, 17), time

		time = parse_now("2 days from this second")
		assert_equal Time.local(2006, 8, 18, 14), time

		#time = parse_now("7 hours before tomorrow at midnight")
		#assert_equal Time.local(2006, 8, 17, 17), time

		# future
	end

	def test_parse_guess_o_r_s_r
		time = parse_now("3rd wednesday in november")
		assert_equal Time.local(2006, 11, 15, 12), time

		time = parse_now("10th wednesday in november")
		assert_equal nil, time

		# time = parse_now("3rd wednesday in 2007")
		# assert_equal Time.local(2007, 1, 20, 12), time
	end

	def test_parse_guess_o_r_g_r
		time = parse_now("3rd month next year")
		assert_equal Time.local(2007, 3, 16, 12), time

		time = parse_now("3rd thursday this september")
		assert_equal Time.local(2006, 9, 21, 12), time

		time = parse_now("4th day last week")
		assert_equal Time.local(2006, 8, 9, 12), time
	end

	def test_parse_guess_nonsense
		time = parse_now("some stupid nonsense")
		assert_equal nil, time

		time = parse_now("Ham Sandwich")
		assert_equal nil, time
	end

	def test_parse_span
		span = parse_now("friday", :guess => false)
		assert_equal Time.local(2006, 8, 18), span.begin
		assert_equal Time.local(2006, 8, 19), span.end

		span = parse_now("november", :guess => false)
		assert_equal Time.local(2006, 11), span.begin
		assert_equal Time.local(2006, 12), span.end

		span = Chronic.parse("weekend" , :now => @time_2006_08_16_14_00_00, :guess => false)
		assert_equal Time.local(2006, 8, 19), span.begin
		assert_equal Time.local(2006, 8, 21), span.end
	end

	def test_parse_with_endian_precedence
		date = '11/02/2007'

		expect_for_middle_endian = Time.local(2007, 11, 2, 12)
		expect_for_little_endian = Time.local(2007, 2, 11, 12)

		# default precedence should be toward middle endianness
		assert_equal expect_for_middle_endian, Chronic.parse(date)

		assert_equal expect_for_middle_endian, Chronic.parse(date, :endian_precedence => [:middle, :little])

		assert_equal expect_for_little_endian, Chronic.parse(date, :endian_precedence => [:little, :middle])
	end

	def test_parse_words
		assert_equal parse_now("33 days from now"), parse_now("thirty-three days from now")
		assert_equal parse_now("2867532 seconds from now"), parse_now("two million eight hundred and sixty seven thousand five hundred and thirty two seconds from now")
		assert_equal parse_now("may 10th"), parse_now("may tenth")
	end

	def test_parse_only_complete_pointers
		assert_equal parse_now("eat pasty buns today at 2pm"), @time_2006_08_16_14_00_00
		assert_equal parse_now("futuristically speaking today at 2pm"), @time_2006_08_16_14_00_00
		assert_equal parse_now("meeting today at 2pm"), @time_2006_08_16_14_00_00
	end

	def test_parse_strip_tokens
		assert_equal Chronic.strip_tokens("eat pasty buns today at 2pm"), "eat pasty buns"
		assert_equal Chronic.strip_tokens("futuristically speaking today at 2pm"), "futuristically speaking"
		assert_equal Chronic.strip_tokens("meeting today at 2pm"), "meeting"
	end

	def test_am_pm
		assert_equal Time.local(2006, 8, 16), parse_now("8/16/2006 at 12am")
		assert_equal Time.local(2006, 8, 16, 12), parse_now("8/16/2006 at 12pm")
	end

	def test_a_p
		assert_equal Time.local(2006, 8, 16, 0, 15), parse_now("8/16/2006 at 12:15a")
		assert_equal Time.local(2006, 8, 16, 18, 30), parse_now("8/16/2006 at 6:30p")
	end

	def test_argument_validation
		assert_raise(Chronic::InvalidArgumentException) do
			time = Chronic.parse("may 27", :foo => :bar)
		end

		assert_raise(Chronic::InvalidArgumentException) do
			time = Chronic.parse("may 27", :context => :bar)
		end
	end

	def test_seasons
		t = parse_now("this spring", :guess => false)
		assert_equal Time.local(2007, 3, 20), t.begin
		assert_equal Time.local(2007, 6, 20), t.end

		t = parse_now("this winter", :guess => false)
		assert_equal Time.local(2006, 12, 22), t.begin
		assert_equal Time.local(2007, 3, 19), t.end

		t = parse_now("last spring", :guess => false)
		assert_equal Time.local(2006, 3, 20), t.begin
		assert_equal Time.local(2006, 6, 20), t.end

		t = parse_now("last winter", :guess => false)
		assert_equal Time.local(2005, 12, 22), t.begin
		assert_equal Time.local(2006, 3, 19), t.end

		t = parse_now("next spring", :guess => false)
		assert_equal Time.local(2007, 3, 20), t.begin
		assert_equal Time.local(2007, 6, 20), t.end
	end

	# regression

	# def test_partial
	#   assert_equal '', parse_now("2 hours")
	# end

	def test_days_in_november
		t1 = Chronic.parse('1st thursday in november', :now => Time.local(2007))
		assert_equal Time.local(2007, 11, 1, 12), t1

		t1 = Chronic.parse('1st friday in november', :now => Time.local(2007))
		assert_equal Time.local(2007, 11, 2, 12), t1

		t1 = Chronic.parse('1st saturday in november', :now => Time.local(2007))
		assert_equal Time.local(2007, 11, 3, 12), t1

		t1 = Chronic.parse('1st sunday in november', :now => Time.local(2007))
		assert_equal Time.local(2007, 11, 4, 12), t1

		# Chronic.debug = true
		#
		# t1 = Chronic.parse('1st monday in november', :now => Time.local(2007))
		# assert_equal Time.local(2007, 11, 5, 11), t1
	end

	def test_parse_strip_tokens_preserved_case
		assert_equal Chronic.strip_tokens("Ham Sandwich"), "Ham Sandwich"
		assert_equal Chronic.strip_tokens("Eat a Ham Sandwich tomorrow"), "Eat a Ham Sandwich"
	end

	def test_parse_this_past
		t = parse_now("this past tuesday")
		assert_equal Time.local(2006,8,15, 12), t

		t = parse_now("this past day")
		assert_equal Time.local(2006,8,15, 12), t

		t = parse_now("this past hour")
		assert_equal Time.local(2006,8,16, 13, 30), t
	end

	def test_parse_noon
		t = parse_now("noon")
		assert_equal Time.local(2006,8,16, 12), t

		t = parse_now("tomorrow at noon")
		assert_equal Time.local(2006,8,17, 12), t
	end

	def test_parse_before_now
		t = parse_now("3 hours before now")
		assert_equal Time.local(2006,8,16, 11), t

		t = parse_now("3 days before now")
		assert_equal Time.local(2006,8,13, 14), t

		t = parse_now("30 minutes before now")
		assert_equal Time.local(2006,8,16, 13,30), t
	end

	def test_now
		t = parse_now("now")
		assert_equal Time.local(2006,8,16,14), t

		t = parse_now("1 hour from now")
		assert_equal Time.local(2006,8,16,15), t

		t = parse_now("1 hour before now")
		assert_equal Time.local(2006,8,16,13), t
	end

	def test_this_last
		t = parse_now("this last day")
		assert_equal Time.local(2006, 8, 15, 12), t

		t = parse_now("this last hour")
		assert_equal Time.local(2006, 8, 16, 13, 30), t
	end

	def test_hr_and_hrs
		t = parse_now("in 3 hr")
		assert_equal Time.local(2006, 8,16,17), t

		t = parse_now("in 3 hrs")
		assert_equal Time.local(2006, 8,16,17), t
	end

	def test_fractional_times
		t = parse_now("in three and a half hours")
		assert_equal Time.local(2006, 8,16,17, 30), t

		t = parse_now("in 3.5 hours")
		assert_equal Time.local(2006, 8,16,17, 30), t
	end
	
	def test_fry_parsed_as_fri
	  # the word "fry" was parsed as "fri"
	  assert_nil(Chronic.parse("Fry"))
	  assert_not_nil(Chronic.parse("Friday"))
	end
	
	def test_date_with_commas
	  t = parse_now("Today, 9pm")
	  assert_equal(Time.local(2006, 8, 16, 21), t)
	  
	  t = parse_now("Meeting, Today, 9pm")
	  assert_equal(Time.local(2006, 8, 16, 21), t)
  end

	private
	def parse_now(string, options={})
		Chronic.parse(string, {:now => TIME_2006_08_16_14_00_00 }.merge(options))
	end
end
