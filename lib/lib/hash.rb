module HashRecursiveBlank
  def rblank
    r = {}
    each_pair do |key, val|
      r[key] = val.rblank if val.is_a?(Hash)
    end
    r.keep_if { |_key, val| val.is_a?(Hash) }
  end

  def rblank!
    each_pair do |key, val|
      self[key] = val.rblank! if val.is_a?(Hash)
    end
    keep_if { |_key, val| val.is_a?(Hash) }
  end
end

module HashRecursiveMerge
  def rmerge(other_hash, concat_if_array = false)
    r = {}
    merge(other_hash) do |key, oldval, newval|
      if oldval.is_a?(Hash)
        r[key] = oldval.rmerge(newval, concat_if_array)
      elsif oldval.is_a?(Array) && newval.is_a?(Array)
        r[key] = concat_if_array ? oldval + newval : newval
      else
        newval
      end
    end
  end

  def rmerge!(other_hash, concat_if_array = false)
    merge!(other_hash) do |_key, oldval, newval|
      if oldval.is_a?(Hash)
        oldval.rmerge!(newval, concat_if_array)
      elsif oldval.is_a?(Array) && newval.is_a?(Array)
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
    (keys + other.keys).uniq.each_with_object({}) do |key, memo|
      next if self[key] == other[key]

      memo[key] = if self[key].is_a?(Hash) && other[key].is_a?(Hash)
                    self[key].diff(other[key])
                  else
                    [self[key], other[key]]
                  end
    end
    end
end

class Hash
  # ensures nested hash from keys, and sets final key to value
  # keys: Array of Symbol|String
  # value: any
  def nested_set(keys, value)
    raise 'DEBUG: nested_set keys must be an Array' unless keys.is_a?(Array)

    final_key = keys.pop
    return unless valid_key?(final_key)

    position = self
    keys.each do |key|
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
