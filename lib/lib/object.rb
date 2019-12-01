class Object
  # Self test Boolean class.
  #
  # @return   boolean
  def boolean?
    self.is_a?(TrueClass) || self.is_a?(FalseClass)
  end

  # Self test Trueclass.
  #
  # @return   boolean
  def true?
    self.is_a?(TrueClass)
  end
  # Self test Falseclass.
  #
  # @return   boolean
  def false?
    self.is_a?(FalseClass)
  end

  # Self test Symbol class.
  #
  # @return   boolean
  def symbol?
    self.is_a?(Symbol)
  end
  # Self test String class.
  #
  # @return   boolean
  def string?
    self.is_a?(String)
  end

  # Self test nil Object class.
  #
  # @return   boolean
  # def nil?
  #   return '' if self == nil
  # end

end