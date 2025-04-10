# QA and SRE work sample
## Overview
This is a Ruby on Rails API service that handles payment method tokenization using Spreedly.

## Setup

### Prerequisites
- Ruby 3.2.2
- Rails 7.1.0
- Bundler

### Installation
1. Clone the repository
2. Install dependencies:
```bash
bundle install
```
3. Start the server with `bundle exec rails s -p 3000`

### Sample request body
```json
{
  "payment_method": {
    "card_number": "4111111111111111",
    "month": "12",
    "year": "2025",
    "first_name": "Test",
    "last_name": "User",
    "cvv": "123"
  }
}
```