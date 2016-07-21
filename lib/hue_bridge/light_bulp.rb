require 'net/http'
require 'json'

module HueBridge
  # Represents a light bulp. It provides an interface to turn the
  # light on, off and to toggle it.
  #
  class LightBulp
    FORBIDDEN_STATS = %w(colormode reachable).freeze

    attr_reader :power, :state

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
    # @return [Boolean] success of the operation
    #
    def toggle
      @power ||= false
      response = put('state', on: !@power)
      set_power_from_response!(response)
      response_successful?(response)
    end

    # Turns the light bulp on and returns it's state.
    # @return [Boolean] success of the operation
    #
    def on
      response = put('state', on: true)
      set_power_from_response!(response)
      response_successful?(response)
    end

    # Turns the light bulp off and returns it's state.
    # @return [Boolean] success of the operation
    #
    def off
      response = put('state', on: false)
      set_power_from_response!(response)
      response_successful?(response)
    end

    # Invokes the alert sequence on the light bulp.
    # @return [Boolean] success of the operation
    #
    def alert
      response = put('state', alert: 'lselect')
      response_successful?(response)
    end

    # Sets the color for the lightbulp.
    # @see Color#initialize
    # @return [Boolean] success of the operation
    #
    def set_color(opts = {})
      color = Color.new(opts)
      response = put('state', color.to_h)

      response_successful?(response)
    end

    # Stores the current state of the lightbulp.
    # @return [Boolean] success of the operation
    #
    def store_state
      response = get
      success = !!(response.body =~ %r(state))
      data = JSON.parse(response.body) if success
      @state = data.fetch('state')
      delete_forbidden_stats
      success
    end

    # Restores the state of the lightbulp.
    # @return [Boolean] success of the operation
    #
    def restore_state
      response = put('state', state)
      success = !!!(response.body =~ %r(error))
    end

    private

    def delete_forbidden_stats
      FORBIDDEN_STATS.each do |attr|
        @state.delete(attr)
      end
    end

    def log_error(msg)
      $stderr.puts(msg)
    end

    def set_power_from_response!(response)
      regex = /success.*\/lights\/\d*\/state\/on.*(?<state>true|false)\}\}\]/
      match = response.body.match(regex) || {}

      @power = case match[:state]
               when nil
                log_error('Couldn\'t determin the power state from the response')
                log_error(response.body)
                false
               when 'true'
                true
               when 'false'
                false
               end
    end

    def response_successful?(response)
      regex = %r((?<state>success|error))
      match = response.body.match(regex) || {}

      case match[:state]
      when nil
        log_error("Don't know how to handle the response")
        log_error(response.body)
        false
      when 'success'
        true
      when 'error'
        false
      end
    end

    def put(resource, params)
      http.request_put("/#{path}/#{resource}", JSON.generate(params))
    end

    def get(resource = '')
      http.request_get("/#{path}/#{resource}")
    end

    def http
      @http ||= Net::HTTP.new(@ip)
    end

    def path
      File.join 'api', @user_id, 'lights', @light_bulp_id.to_s
    end
  end
end
