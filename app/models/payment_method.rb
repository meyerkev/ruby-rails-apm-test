class PaymentMethod
  attr_reader :id, :token, :last_four, :created_at

  def initialize(token:, last_four:)
    @id = "pm_#{SecureRandom.hex(10)}"
    @token = token
    @last_four = last_four
    @created_at = Time.current
  end
end