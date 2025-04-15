# app/controllers/api/v1/payment_methods_controller.rb

module Api
  module V1
    class PaymentMethodsController < ApplicationController
      before_action :authenticate_request

      def tokenize
        unless valid_test_card?(payment_method_params[:card_number])
          render_error(
            'Only test cards are allowed',
            :unprocessable_entity
          )
          return
        end

        begin
          test_response = tokenize_payment_method
          stored_token = mock_store_payment_method(test_response)
          StatsD.increment('payment_method.tokenized')

          render json: successful_response(test_response, stored_token)
          return
        rescue TESTError => e
          render_error('TEST tokenization error', :internal_server_error)
          return 
        rescue StandardError => e
          Rails.logger.info(e)
          render_error('Unexpected error occurred', :internal_server_error)
          return
        end
      end

      private

      def authenticate_request
        unless request.authorization.present?
          render_error('Authorization header missing', :unauthorized )
          return 
        end

        username, password = ActionController::HttpAuthentication::Basic.user_name_and_password(request)

        unless username == ENV['DEVELOPMENT_USERNAME'] && password == ENV['DEVELOPMENT_PASSWORD']
          render_error('Invalid credentials', :unauthorized )
          return 
        end
      end

      def payment_method_params
        params.require(:payment_method).permit(
          :card_number,
          :month,
          :year,
          :first_name,
          :last_name,
          :cvv,
          :email
        )
      end

      def valid_test_card?(card_number)
        test_cards = ['4111111111111111', '5555555555554444']
        test_cards.include?(card_number)
      end

      def tokenize_payment_method
        test_service.tokenize_card(payment_method_params)
      end

      def test_service
        @test_service ||= TESTService.new
      end

      def mock_store_payment_method(test_response)
        payment_token = test_response.dig('transaction', 'payment_method', 'token')
        stored_payment = PaymentMethod.new(
          token: payment_token,
          last_four: payment_method_params[:card_number]&.last(4)
        )
        stored_payment.id
      end

      def successful_response(test_response, stored_token)
        {
          status: 'success',
          payment_method_token: test_response.dig('transaction', 'payment_method', 'token'),
          stored_id: stored_token,
          created_at: Time.current.iso8601
        }
      end

      def render_error(message, status)
        render json: {
          error: message
        }, status: status
        return
      end
    end
  end
end