# frozen_string_literal: true

# For all strings
class String
  def humanize
    capitalize.split('_').join(' ')
  end
end
