# app/services/test_service.rb
require 'httparty'

class TESTService
  include HTTParty
  base_uri 'https://core.test.com/v1'
  format :json
  
  def initialize
    @environment_key = ENV.fetch('TEST_ENVIRONMENT_KEY')
  end

  def tokenize_card(card_params)
    options = {
      body: build_request_body(card_params),
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      },
      timeout: 5
    }

    response = self.class.post('/payment_methods.json', options)
    handle_response(response)
  rescue Net::OpenTimeout, Net::ReadTimeout
    raise TESTError.new('Request timed out', 'TIMEOUT')
  rescue SocketError
    raise TESTError.new('Connection failed', 'CONNECTION_ERROR')
  end

  private

  def build_request_body(card_params)
    {
      payment_method: {
        credit_card: {
          number: card_params[:card_number],
          verification_value: card_params[:cvv],
          month: card_params[:month],
          year: card_params[:year],
          first_name: card_params[:first_name],
          last_name: card_params[:last_name],
          email: card_params[:email]
        },
        retained: true
      },
      environment_key: @environment_key
    }.to_json
  end

  def handle_response(response)
    case response.code
    when 200, 201
      StatsD.increment('test.success')
      response.parsed_response
    when 401, 403
      raise TESTError.new('Authentication failed', 'AUTH_ERROR')
    when 422
      error_message = extract_error_message(response)
      raise TESTError.new(error_message, 'VALIDATION_ERROR')
    when 429
      raise TESTError.new('Rate limit exceeded', 'RATE_LIMIT')
    else
      StatsD.increment('test.failure')
      Rails.logger.error "TEST API error: #{response.code} - #{response.body}"
      raise TESTError.new('Unexpected error', 'API_ERROR')
    end
  end

  def extract_error_message(response)
    parsed_response = response.parsed_response
    errors = parsed_response['errors'] || []
    errors.first&.dig('message') || 'Validation failed'
  end
end

class TESTError < StandardError
  attr_reader :code
  
  def initialize(message, code)
    @code = code
    super(message)
  end
end