module HueBridge
  # Error raised when passing or setting invalid options.
  class InvalidColorOption < StandardError; end

  # Value object to represent a color
  class Color
    attr_reader :hue, :bri, :sat

    # @param opts [Hash] the color options
    # @option opts :bri The brightness
    # @option opts :hue The hue
    # @option opts :sat The saturation
    def initialize(opts = {})
      [:bri, :hue, :sat].each do |attr|
        value = opts.fetch(attr, false)
        send("#{attr}=", value) if value
      end
    end

    # Returns a hash containing the color options.
    #
    # @return [Hash] the options
    def to_h
      hash = {}
      [:bri, :hue, :sat].each do |attr|
        value = send(attr)
        hash[attr] = value if value
      end
      hash
    end

    alias to_hash to_h

    # Sets the hue. Only values between 0 and 65535 are allowed.
    # @param [Integer] value
    def hue=(value)
      fail InvalidColorOption,
           'Invalid hue' unless value.between?(0, 65535)
      @hue = value
    end

    # Sets the saturation. Only values between 0 and 254 are allowed.
    # @param [Integer] value
    def sat=(value)
      fail InvalidColorOption,
           'Invalid saturation' unless value.between?(0, 254)
      @sat = value
    end

    # Sets the brightness. Only values between 1 and 254 are allowed.
    # @param [Integer] value
    def bri=(value)
      fail InvalidColorOption,
           'Invalid brightness' unless value.between?(1, 254)
      @bri = value
    end
  end
end
