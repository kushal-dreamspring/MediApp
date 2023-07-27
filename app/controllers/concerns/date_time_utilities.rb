# frozen_string_literal: true

module DateTimeUtilities
  extend ActiveSupport::Concern

  def combine_date_and_time(date, time)
    DateTime.new(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.min,
      time.sec,
      time.zone
    )
  end
end
