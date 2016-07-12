require 'rest-client'
require 'json'

module HueBridge
  # Represents a light bulp. It provides an interface to turn the
  # light on, off and to toggle it.
  #
  class LightBulp
    # @param [String] ip The Hue Bridge's IP
    # @param [String] user_id The user id to access the api
    # @param [Integer] light_bulp_id The id of the light bulp
    #
    def initialize(ip, user_id, light_bulp_id)
      @light_bulp_id = light_bulp_id
      @user_id = user_id
      @ip = ip
    end

    # Toggles the light bulp and returns it's state.
    # @return [Boolean] The state
    #
    def toggle
      response = put("state", on: !@state)
      @state = get_state_from_response(response)
    end

    # Turns the light bulp on and returns it's state.
    # @return [Boolean] The state
    #
    def on
      response = put("state", on: true)
      @state = get_state_from_response(response)
    end

    # Turns the light bulp off and returns it's state.
    # @return [Boolean] The state
    #
    def off
      response = put("state", on: false)
      @state = get_state_from_response(response)
    end

    private

    def log_error(msg)
      $stderr.puts(msg)
    end

    def get_state_from_response(response)
      regex = /success.*\/lights\/\d*\/state\/on.*(?<state>true|false)\}\}\]/
      match = response.body.match(regex) || {}

      case match[:state]
      when nil
        log_error("Couldn't determin the state from the response")
        log_error(response.body)
        false
      when 'true'
        true
      when 'false'
        false
      end
    end

    def put(resource, params)
      RestClient.put(url(resource), JSON.generate(params))
    end

    def url(resource = nil)
      File.join @ip, 'api', @user_id,
        'lights', @light_bulp_id.to_s, resource.to_s
    end
  end
end
