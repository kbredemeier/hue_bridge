require 'net/http'
require 'json'

module HueBridge
  # Represents a light bulp. It provides an interface to turn the
  # light on, off and to toggle it.
  #
  class LightBulp
    # @param [Hash] options LightBulp options
    # @option options [String] :hue_bridge_ip The Hue Bridge's IP
    # @option options [String] :user_id The user id to access the api
    # @option options [Integer] :light_bulp_id The id of the light bulp
    #
    def initialize(options = {})
      @light_bulp_id = options.fetch(:light_bulp_id)
      @user_id = options.fetch(:user_id)
      @ip = options.fetch(:hue_bridge_ip)
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
      http = Net::HTTP.new(@ip)
      http.request_put("/#{path}/#{resource}", JSON.generate(params))
    end

    def path
      File.join 'api', @user_id, 'lights', @light_bulp_id.to_s
    end
  end
end
