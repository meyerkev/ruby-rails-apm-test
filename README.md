# QA and SRE work sample

## Overview

This is a Ruby on Rails API service that handles payment method tokenization using TEST.

## Setup

### Prerequisites

- Ruby 3.2.8
- Rails 7.1.0
- Bundler

On MAC OSX on Linuxbrew systems, you can run this

```bash
# install ruby
brew install ruby@3.2

# add ruby 3.2 to your path (bash/zsh/fish—pick your poison)
echo 'export PATH="/opt/homebrew/opt/ruby@3.2/bin:$PATH"' >> ~/.zprofile
source ~/.zprofile

# verify
ruby -v  # should be 3.2.2

# install bundler + rails
gem install bundler
gem install rails -v 7.1.0
```

rails might complain about openssl or readline, in which case install them via brew:

```bash
brew install openssl readline
```

if stuff breaks, bundle config set --local build.openssl_dir $(brew --prefix openssl) might help.

### Installation
1. Clone the repository
2. Install dependencies:
```bash
bundle install
```
3. Start the server with `bundle exec rails s -p 3000`

### Testing

Sample request body
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

### Testing with curl

Generate a 401:
```bash
curl -X POST http://localhost:3000/api/v1/payment_methods/tokenize \
  -H "Content-Type: application/json" \
  -d '{
    "payment_method": {
      "card_number": "4111111111111111",
      "month": "12",
      "year": "2025",
      "first_name": "Test",
      "last_name": "User",
      "cvv": "123"
    }
  }'
```

This should return a 200 with correct headers
(Validate the user and password in .env file)

Use `curl -i` 

```bash
curl -X POST http://localhost:3000/api/v1/payment_methods/tokenize \
  -u X:development \
  -H "Content-Type: application/json" \
  -d '{
    "payment_method": {
      "card_number": "4111111111111111",
      "month": "12",
      "year": "2025",
      "first_name": "Test",
      "last_name": "User",
      "cvv": "123"
    }
  }'
```

or

```bash
curl -X POST http://localhost:3000/api/v1/payment_methods/tokenize \
  -H "Authorization: Basic $(echo -n 'X:development' | base64)" \
  -H "Content-Type: application/json" \
  -d '{
    "payment_method": {
      "card_number": "4111111111111111",
      "month": "12",
      "year": "2025",
      "first_name": "Test",
      "last_name": "User",
      "cvv": "123"
    }
  }'
```