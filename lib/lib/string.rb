class String

  # Justity relative left or right position filled with a espefific char in String.
  #
  # sample:
  #
  #  "TESTE".fix(10,'xy') # => xxxxxTESTE
  #  "TESTE".fix(-10,'xy') # => TESTExxxxx
  #
  # @param    size to justify.
  # @param    pattern pattern do justify
  # @return   formated string
  def fix(size, pattern=' ')
    if size >= 0
      self[0...size].rjust(size, pattern)
    else
      diff = size.abs - self.size
      self + ''.fix(diff,pattern)
    end
  end

  # Encrypt a string using a key.
  # sample
  # msg       = "teste do encrypt".light_blue
  # passwd    = 'tools999'
  # encrypted = msg.encrypt passwd
  # puts (encrypted.decrypt passwd)
  # @return   encrypt string
  def encrypt(key)
    Encrypt.dump self, key
  end

  # Decrypt a string using a key.
  # sample
  # msg       = "teste do encrypt".light_blue
  # passwd    = 'tools999'
  # encrypted = msg.encrypt passwd
  # puts (encrypted.decrypt passwd)
  # @return   decrypt string
  def decrypt(key)
    Encrypt.load self, key
  end

  # Self test numeric String class.
  #
  # @return   boolean
  def numeric?
    Float(self) != nil rescue false
  end

  # Self test digits String class.
  #
  # @return   boolean
  def num?
    !!match(/^[[:digit:]]+$/)
  end

  # Self test alphanum String class.
  #
  # @return   boolean
  def alnum?
    !!match(/^[[:alnum:]]+$/)
  end

  # Self test alpha String class.
  #
  # @return   boolean
  def alpha?
    !!match(/^[[:alpha:]]+$/)
  end

  def help?
    if self.eql? '?'      or
       self.eql? '-h'     or
       self.eql? '--help' or
       self.eql? 'help'
       return true
    else
      return false
    end
  end

end