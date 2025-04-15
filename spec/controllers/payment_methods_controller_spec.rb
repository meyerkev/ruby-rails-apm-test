require 'rails_helper'

RSpec.describe Api::V1::PaymentMethodsController do
  let(:valid_credentials) do
    ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV['DEVELOPMENT_USERNAME'],
      ENV['DEVELOPMENT_PASSWORD']
    )
  end

  let(:valid_params) do
    {
      payment_method: {
        card_number: '4111111111111111',
        month: '12',
        year: '2025',
        first_name: 'Test',
        last_name: 'User',
        cvv: '123',
        email: 'test@example.com'
      }
    }
  end

  describe 'POST #tokenize' do
    context 'with authentication' do
      before do
        request.headers['Authorization'] = valid_credentials
      end

      context 'with valid test card' do
        let(:test_response) do
          {
            'transaction' => {
              'payment_method' => {
                'token' => 'test_token'
              }
            }
          }
        end

        before do
          allow_any_instance_of(TESTService).to receive(:tokenize_card).and_return(test_response)
          allow(PaymentMethod).to receive(:new).and_return(double(id: 123))
        end

        it 'returns success response' do
          post :tokenize, params: valid_params
          
          expect(response).to have_http_status(:success)
          
          body = JSON.parse(response.body)
          expect(body['status']).to eq('success')
          expect(body['payment_method_token']).to eq('test_token')
          expect(body['stored_id']).to eq(123)
          expect(body['created_at']).to be_present
        end
      end

    end
  end
end