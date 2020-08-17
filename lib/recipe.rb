class Recipe
  attr_reader :name, :description, :prep_time, :difficulty

  def initialize(name, description, done = false, prep_time = '', difficulty = '')
    @name = name
    @description = description
    @done = done
    @prep_time = prep_time
    @difficulty = difficulty
  end

  def done?
    @done
  end

  def mark_done!
    @done = true
  end
end
