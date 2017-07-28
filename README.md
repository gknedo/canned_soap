[![Gem Version](https://badge.fury.io/rb/canned_soap.svg)](https://badge.fury.io/rb/canned_soap)
# CannedSoap

A rewrite version of the [ruby2soap](https://github.com/ericman93/ruby2soap) gem.

## Motivation
The original gem has a lot of bugs and don't work on Linux environments. I started to maintain an old gem that uses this gem, so I started to maintain this gem too.

## Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'canned_soap'
```

And then execute:

```sh
bundle install
```

Or if you don't use bundler:

```sh
gem install canned_soap
```


## Usage

### Initialize the client

```ruby
client = CannedSoap::Client.new('http://www.webservicex.net/CurrencyConvertor.asmx')
```

### Simple objects
```ruby
client.ConversionRate(FromCurrency: 'ILS', ToCurrency: 'GBP')
```

### Statefull
```ruby
client.Init(userName: 'ericman93')
client.IncreaseScore() #the cookies saved automaticly
```

### Complex type
```ruby
client = CannedSoap::Client.new('http://localhost:1659/Service1.svc')
res = client.GetDataUsingDataContract(composite: {BoolValue: true, StringValue: "canedo_soap"})
```

## Authentication
Available authentications
1. NTLM
2. Basic
3. Digest

### NTLM Auth
```ruby
client.ConversionRate({:FromCurrency => 'ILS', :ToCurrency => 'GBP'},SecutryProtocol::NTLM,'user','password')
```
### With domain
```ruby
client.ConversionRate({:FromCurrency => 'ILS', :ToCurrency => 'GBP'},SecutryProtocol::NTLM,'user','password','domain')
```
