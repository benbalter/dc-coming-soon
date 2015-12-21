module PostingsHelper

  def distance_to_human(distance)
    case distance.to_f
    when 0.25
      "a quarter of a mile"
    when 0.5
      "half a mile"
    when 1.0
      "one mile"
    end
  end
end
