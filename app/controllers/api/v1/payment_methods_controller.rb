# app/controllers/api/v1/payment_methods_controller.rb

module Api
  module V1
    class PaymentMethodsController < ApplicationController
      before_action :authenticate_request

      def tokenize
        unless valid_test_card?(payment_method_params[:card_number])
          return render_error(
            'Only test cards are allowed',
            :unprocessable_entity
          )
        end

        begin
          spreedly_response = tokenize_payment_method
          stored_token = mock_store_payment_method(spreedly_response)
          StatsD.increment('payment_method.tokenized')

          render json: successful_response(spreedly_response, stored_token)
        rescue SpreedlyError => e
          render_error('Spreedly tokenization error', :internal_server_error)
        rescue StandardError => e
          Rails.logger.info(e)
          render_error('Unexpected error occurred', :internal_server_error)
        end
      end

      private

      def authenticate_request
        render json: {} , status: :internal_server_error unless request.authorization.present?

        username, password = ActionController::HttpAuthentication::Basic.user_name_and_password(request)

        render json: {} , status: :internal_server_error unless username == ENV['DEVELOPMENT_USERNAME'] && password == ENV['DEVELOPMENT_PASSWORD']
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
        spreedly_service.tokenize_card(payment_method_params)
      end

      def spreedly_service
        @spreedly_service ||= SpreedlyService.new
      end

      def mock_store_payment_method(spreedly_response)
        payment_token = spreedly_response.dig('transaction', 'payment_method', 'token')
        stored_payment = PaymentMethod.new(
          token: payment_token,
          last_four: payment_method_params[:card_number]&.last(4)
        )
        stored_payment.id
      end

      def successful_response(spreedly_response, stored_token)
        {
          status: 'success',
          payment_method_token: spreedly_response.dig('transaction', 'payment_method', 'token'),
          stored_id: stored_token,
          created_at: Time.current.iso8601
        }
      end

      def render_error(message, status)
        render json: {
          error: message
        }, status: status
      end
    end
  end
end