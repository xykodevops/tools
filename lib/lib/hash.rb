module HashRecursiveBlank
  def rblank
    r = {}
    each_pair do |key, val|
      r[key] = val.rblank if val.is_a?(Hash)
    end
    return r.keep_if { |key, val| val.is_a?(Hash) }
  end

  def rblank!
    each_pair do |key, val|
      self[key] = val.rblank! if val.is_a?(Hash)
    end
    return keep_if { |key, val| val.is_a?(Hash) }
  end
end

module HashRecursiveMerge
  def rmerge(other_hash, concat_if_array = false)
    r = {}
    return merge(other_hash) do |key, oldval, newval|
      if oldval.is_a?(Hash)
        r[key] = oldval.rmerge(newval, concat_if_array)
      elsif oldval.is_a?(Array) and newval.is_a?(Array)
        r[key] = concat_if_array ? oldval + newval : newval
      else
        newval
      end
    end
  end

  def rmerge!(other_hash, concat_if_array = false)
    return merge!(other_hash) do |key, oldval, newval|
      if oldval.is_a?(Hash)
        oldval.rmerge!(newval, concat_if_array)
      elsif oldval.is_a?(Array) and newval.is_a?(Array)
        concat_if_array ? oldval + newval : newval
      else
        newval
      end
    end
  end
end

class Hash
  include HashRecursiveMerge
  include HashRecursiveBlank

  def diff(other)
      (self.keys + other.keys).uniq.inject({}) do |memo, key|
        unless self[key] == other[key]
          if self[key].kind_of?(Hash) &&  other[key].kind_of?(Hash)
            memo[key] = self[key].diff(other[key])
          else
            memo[key] = [self[key], other[key]]
          end
        end
        memo
      end
    end
end


class Hash

  # ensures nested hash from keys, and sets final key to value
  # keys: Array of Symbol|String
  # value: any
  def nested_set(keys, value)
    raise "DEBUG: nested_set keys must be an Array" unless keys.is_a?(Array)

    final_key = keys.pop
    return unless valid_key?(final_key)
    position = self
    for key in keys
      return unless valid_key?(key)
      position[key] = {} unless position[key].is_a?(Hash)
      position = position[key]
    end
    position[final_key] = value
  end

  private

  # returns true if key is valid
  def valid_key?(key)
    return true if key.is_a?(Symbol) || key.is_a?(String)
    raise "DEBUG: nested_set invalid key: #{key} (#{key.class})"
  end

end