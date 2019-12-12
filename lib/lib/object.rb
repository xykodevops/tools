class Object
  # Self test Boolean class.
  #
  # @return   boolean
  def boolean?
    is_a?(TrueClass) || is_a?(FalseClass)
  end

  # Self test Trueclass.
  #
  # @return   boolean
  def true?
    is_a?(TrueClass)
  end

  # Self test Falseclass.
  #
  # @return   boolean
  def false?
    is_a?(FalseClass)
  end

  # Self test Symbol class.
  #
  # @return   boolean
  def symbol?
    is_a?(Symbol)
  end

  # Self test String class.
  #
  # @return   boolean
  def string?
    is_a?(String)
  end

  # Self empty? class.
  #
  # @return   boolean
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  # Self blank class.
  #
  # @return   boolean
  def present?
    !blank?
  end

end
