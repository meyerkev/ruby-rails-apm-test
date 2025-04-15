require 'rails_helper'

RSpec.describe TESTService do
  let(:service) { TESTService.new }
  let(:card_params) do
    {
      card_number: '4111111111111111',
      cvv: '123',
      month: '12',
      year: '2025',
      first_name: 'Test',
      last_name: 'User',
      email: 'test@example.com'
    }
  end

  describe '#tokenize_card' do
    let(:success_response) do
      {
        'transaction' => {
          'token' => 'payment_method_token',
          'payment_method' => {
            'token' => 'card_token',
            'last_four_digits' => '1111'
          }
        }
      }
    end

    before do
      stub_request(:post, "https://core.spreedly.com/v1/payment_methods.json")
        .with(
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
          }
        )
        .to_return(
          status: 200,
          body: success_response.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'successfully tokenizes a card' do
      response = service.tokenize_card(card_params)
      expect(response).to eq(success_response)
    end

    it 'successfully increments success metric' do
      expect { service.tokenize_card(card_params) }.to trigger_statsd_increment('spreedly.success')
    end

    context 'when API returns an error' do
      before do
        stub_request(:post, "https://core.spreedly.com/v1/payment_methods.json")
          .to_return(
            status: 422,
            body: {
              errors: [{ message: 'Invalid card number' }]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'raises a TESTError with the error message' do
        expect {
          service.tokenize_card(card_params)
        }.to raise_error(TESTError, 'Invalid card number')
      end
    end
  end
end