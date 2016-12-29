class Card
  attr_reader :value
  attr_accessor :face_up

  def initialize(value)
    @value = value
    @face_up = false
  end

  def to_s
    face_up ? value : "#"
  end

  def reveal
    self.face_up = true
  end

  def hide
    self.face_up = false
  end

end
