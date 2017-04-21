module SimpleTk
  ##
  # A helper class to make hash ivars more useful.
  class GetSetHelper

    ##
    # Creates a helper for a specific hash in a parent object.
    #
    # This helper does not support adding items to the connected hash.
    #
    # Parameters:
    # parent::      The parent object this helper accesses.
    # hash_ivar::   The name (as a symbol) of the instance variable in the parent object to access.
    #               (eg - :@data)
    # auto_symbol:: Should names be converted to symbols in the accessors, defaults to true.
    # getter::      The method or proc to call when getting a value.
    #               If this is a Symbol then it defines the method name of the retrieved value to call.
    #               If this is a Proc then it will be called with the retrieved value as an argument.
    #               If this is nil then the retrieved value is returned.
    # setter:       The method or proc to call when setting a value.
    #               If this is a Symbol then it defines the method name of the retrieved value to call with the new value.
    #               If this ia a Proc then it will be called with the retrieved value and the new value as arguments.
    #               If this is nil then the hash value is replaced with the new value.
    #
    #   GetSetHelper.new(my_obj, :@data)
    #   GetSetHelper.new(my_obj, :@data, true, :value, :value=)
    #   GetSetHelper.new(my_obj, :@data, true, ->(v){ v.value }, ->(i,v){ i.value = v })
    def initialize(parent, hash_ivar, auto_symbol = true, getter = nil, setter = nil)
      @parent = parent
      @hash_ivar = hash_ivar
      @auto_symbol = auto_symbol
      @getter = getter
      @setter = setter
    end

    ##
    # Gets the value for the given name.
    def [](name)
      name = name.to_sym if @auto_symbol
      h = @parent.instance_variable_get(@hash_ivar)
      if h.include?(name)
        v = h[name]
        if @getter.is_a?(Symbol)
          v.send @getter
        elsif @getter.is_a?(Proc)
          @getter.call v
        else
          v
        end
      else
        raise IndexError
      end
    end

    ##
    # Sets the value for the given name.
    def []=(name, value)
      name = name.to_sym if @auto_symbol
      h = @parent.instance_variable_get(@hash_ivar)
      if h.include?(name)
        if @setter.is_a?(Symbol)
          h[name].send @setter, value
        elsif @setter.is_a?(Proc)
          @setter.call h[name], value
        else
          h[name] = value
        end
      else
        raise IndexError
      end
    end

  end
end